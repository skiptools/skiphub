package example.app

/*
import androidx.activity.compose.BackHandler
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.runtime.snapshots.SnapshotStateList
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.em
import androidx.compose.ui.unit.sp
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.compose.*
import skip.foundation.warning


class ModelObservableObject {
    var modelValue = 0
        // Synthesized for @Published vars
        set(value) {
            objectWillChange()
            field = value
        }

    // Synthesized
    // TODO: Allow multiple subscribers
    var objectWillChange: () -> Unit = {}
}

class StateObservableObject {
    var stateValue = 0
        // Synthesized for @Published vars
        set(value) {
            objectWillChange()
            field = value
        }

    // Synthesized
    var objectWillChange: () -> Unit = {}
}

class EnvironmentObservableObject {
    var environmentObjectValue = 0
        // Synthesized for @Published vars
        set(value) {
            objectWillChange()
            field = value
        }

    // Synthesized
    var objectWillChange: () -> Unit = {}
}

/////////////////////////////////

// Base class for all Views
open class View {
    @Composable
    open fun Compose(context: ComposeContext) {
    }

    // Modifiers we've added support for

    fun background(color: Color): View {
        return BackgroundModifier(this, color)
    }

    fun border(width: Int): View {
        return BorderModifier(this, width)
    }

    fun environmentObject(environmentObject: Any): View {
        return EnvironmentObjectModifier(this, environmentObject)
    }

    fun fixedSize(): View {
        return FixedSizeModifier(this)
    }

    fun font(name: String): View {
        return FontModifier(this, name)
    }

    fun padding(width: Int): View {
        return PaddingModifier(this, width)
    }

    fun sheet(isPresented: Binding<Boolean>, content: () -> View): View {
        return SheetModifier(this, isPresented, content)
    }
}

class Binding<T>(val get: () -> T, val set: (T) -> Unit) {
    var wrappedValue: T
        get() = get()
        set(value) {
            set(value)
        }
}

// TODO: Cleanup this API and implementation
class ComposeContext(val environment: Environment = Environment(), val modifier: Modifier = Modifier, val restoreStateNode: StateNode? = null) {
    // Create a derivative context for a child view. If no restore state node is provided but this
    // context has a non-nil state graph, the derivative context will traverse to the named node,
    // adding it to the graph if needed. Thus the view receiving this context will be able to load
    // and store state for restorations
    fun push(nodeName: String, environmentObject: Any? = null, modifier: Modifier = Modifier, restoreStateNode: StateNode? = null): ComposeContext {
        if (restoreStateNode != null) {
            this.restoreStateNode?.addChild(restoreStateNode)
        }
        val stateNode = restoreStateNode ?: this.restoreStateNode?.child(nodeName, create = true)
        var environment = this.environment
        if (environmentObject != null) {
            environment = Environment(this.environment.objects + environmentObject)
        }
        return ComposeContext(environment, modifier, stateNode)
    }

    // Derive a context with updated modifiers without adding to the state graph
    fun modifier(modifier: Modifier): ComposeContext {
        return ComposeContext(environment, modifier, restoreStateNode)
    }

    // Derive a context with updated environment objects without adding to the state graph
    fun environmentObject(value: Any): ComposeContext {
        return ComposeContext(Environment(environment.objects + value), modifier, restoreStateNode)
    }
}

// TODO: Cleanup this API and implementation
class StateNode(val name: String) {
    var value: Any? = null
    private var children: MutableList<StateNode> = mutableListOf()

    fun child(named: String, create: Boolean = false): StateNode? {
        var node = children.firstOrNull { it.name == named }
        if (node == null && create) {
            node = addChild(StateNode(named))
        }
        return node
    }

    fun addChild(node: StateNode): StateNode {
        children.removeAll { it.name == node.name }
        children.add(node)
        return node
    }
}

// TODO: Real Environment system
class Environment(val objects: List<Any> = listOf()) {
}

// Views we've added support for

class ButtonView(val onClick: () -> Unit): View() {
    @Composable
    override fun Compose(context: ComposeContext): Unit {
        Button(onClick = onClick, modifier = context.modifier) {
            Text("Tap me")
        }
    }
}

class NavigationLink(val text: String, val destination: Any): View() {
    @Composable
    override fun Compose(context: ComposeContext): Unit {
        val navigator = context.environment.objects.firstOrNull { it is NavigationStack.Navigator } as? NavigationStack.Navigator
        Button({ navigator?.navigateTo?.invoke(destination) }) {
            Text(text)
        }
    }
}

// TODO: Cleanup internals, add support for standard navigation API including replacing the
// destinationMap with the .navigationDestination modifier, integrate with top app bar
class NavigationStack(val destinationMap: (Any) -> View, val content: () -> View): View() {
    class Navigator(val navigateTo: (Any) -> Unit) {
    }

    // Keep the back stack as a Pair of the object that is mapped to the destination view and
    // any restorable state node we've recorded for that view
    @Stable
    class State(var stack: SnapshotStateList<Pair<Any, StateNode?>>) {
    }

    @Composable
    override fun Compose(context: ComposeContext): Unit {
        val navController = rememberNavController()

        // TODO: Cleanup this whole pattern because we need to use it in our own stateful
        // SwiftUI view clones, not just in synthesized custom view code
        var isFirstCompose by remember { mutableStateOf(true) }
        SideEffect {
            isFirstCompose = false
        }
        val restoreState = if (isFirstCompose) context.restoreStateNode?.value as? State else null
        logger.warning("Compose NavigationStack isFirstCompose=$isFirstCompose, restore state = ${context.restoreStateNode?.value})")
        val state = remember { restoreState ?: State(mutableStateListOf(Pair("", null))) }
        val stack = state.stack
        context.restoreStateNode?.value = state

        val navigator = Navigator({
            stack.add(Pair(it, null))
            navController.navigate("0")
        })

        // TODO: If two NavigationStacks are alive at once - e.g. presenting a sheet with its own
        // NavigationStack - this will probably get called on all of them. Fix
        BackHandler(enabled = true) {
            stack.removeLast()
            navController.navigate("0")
        }
        NavHost(navController = navController, startDestination = "0") {
            // Compose wants a complete map of all navigation routes, which is not how SwiftUI operates.
            // So instead we create a single dynamic route that navigates to the top entry in the nav stack
            composable("0") {
                val stackEntry = stack.last()
                val restoreStateNode = stackEntry.second
                val nodeName = "NavigationStack.content"
                val contentContext = context.push(nodeName, navigator, Modifier, restoreStateNode ?: StateNode(nodeName))
                if (stack.count() == 1) {
                    content().Compose(contentContext)
                } else {
                    destinationMap(stackEntry.first).Compose(contentContext)
                }
                // Record the restore state now that we've composed the view and it is populated
                // with the latest view state
                stack[stack.lastIndex] = Pair(stackEntry.first, contentContext.restoreStateNode)
            }
        }
    }
}

// TODO: Cleanup internals, add support for standard tab item API, integrate with bottom nav bar
class TabView(val contentViews: () -> List<View>): View() {
    @Composable
    override fun Compose(context: ComposeContext): Unit {
        val navController = rememberNavController()
        // TODO: Should be using our restorable state pattern for its own state
        var selectedTab by remember { mutableStateOf(0) }

        // TODO: This is all a giant hack hardcoding three tabs. Fix
        var tabState: MutableList<StateNode?> = remember { mutableStateListOf(null, null, null) }
        fun selectTab(index: Int) {
            selectedTab = index
            navController.navigate(index.toString()) {
                popUpTo(navController.graph.findStartDestination().id)
                launchSingleTop = true
            }
        }
        Column {
            NavHost(navController = navController, startDestination = selectedTab.toString()) {
                // While this is currently a huge hack and this code needs refactoring to remove duplication,
                // we might consider only supporting a certain maximum number of tabs using hardcoded routes like this
                composable("0") {
                    val view = contentViews()[0]
                    val nodeName = "TabView.0"
                    // As in the NavigationStack, we supply any remembered restoration state to each tab and
                    // then record its state for future restoration after compose
                    val tabContext = context.push(nodeName, restoreStateNode = tabState[0] ?: StateNode(nodeName))
                    Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                        view.Compose(tabContext)
                        tabState[0] = tabContext.restoreStateNode
                        logger.warning("0 restore state: ${tabContext.restoreStateNode?.value}")
                    }
                }
                composable("1") {
                    val view = contentViews()[1]
                    val nodeName = "TabView.1"
                    val tabContext = context.push(nodeName, restoreStateNode = tabState[1] ?: StateNode(nodeName))
                    Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                        view.Compose(tabContext)
                        tabState[1] = tabContext.restoreStateNode
                        logger.warning("1 restore state: ${tabContext.restoreStateNode?.value}")
                    }
                }
                composable("2") {
                    val view = contentViews()[2]
                    val nodeName = "TabView.2"
                    val tabContext = context.push(nodeName, restoreStateNode = tabState[2] ?: StateNode(nodeName))
                    Box(modifier = Modifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                        view.Compose(tabContext)
                        tabState[2] = tabContext.restoreStateNode
                        logger.warning("2 restore state: ${tabContext.restoreStateNode?.value}")
                    }
                }
            }
            // TODO: Implement actual tabs and integrate with the bottom nav bar
            Row(modifier = Modifier.fillMaxWidth()) {
                Button({ selectTab(0) }, modifier = Modifier.fillMaxWidth().weight(1.0f)) {
                    Text("1")
                }
                Button({ selectTab(1) }, modifier = Modifier.fillMaxWidth().weight(1.0f)) {
                    Text("2")
                }
                Button({ selectTab(2) }, modifier = Modifier.fillMaxWidth().weight(1.0f)) {
                    Text("3")
                }
            }
        }
    }
}

class TextFieldView(val binding: Binding<String>): View() {
    @Composable
    override fun Compose(context: ComposeContext): Unit {
        // Mimic SwiftUI behavior of spanning full width unless fixedSize has been set
        var modifier = context.modifier
        if (!context.modifier.any { it == Modifier.width(intrinsicSize = IntrinsicSize.Min) }) {
            modifier = Modifier.fillMaxWidth().then(modifier)
        }
        TextField(value = binding.get(), onValueChange = { binding.set(it) }, modifier = modifier)
    }
}

class TextView(val text: String): View() {
    @Composable
    override fun Compose(context: ComposeContext) {
        // TODO: Hacked to respond with this hardcoded larger font when any font string has
        // been placed in the environment. Implement actual Font support
        val fontNameIndex = context.environment.objects.indexOfFirst { it is String }
        val fontSize = if (fontNameIndex == -1) TextUnit.Unspecified else 14.0.em
        Text(text, fontSize = fontSize, modifier = context.modifier)
    }
}

class VStackView(val content: () -> List<View>): View() {
    @Composable
    override fun Compose(context: ComposeContext) {
        Column(modifier = context.modifier, horizontalAlignment = Alignment.CenterHorizontally) {
            content().forEachIndexed { index, element ->
                element.Compose(context.push("VStackView.$index"))
            }
        }
    }
}

class BackgroundModifier(val target: View, val color: Color): View() {
    @Composable
    override fun Compose(context: ComposeContext) {
        target.Compose(context.modifier(context.modifier.background(color)))
    }
}

class BorderModifier(val target: View, val width: Int): View() {
    @Composable
    override fun Compose(context: ComposeContext): Unit {
        target.Compose(context.modifier(context.modifier.border(width.dp, Color.Black)))
    }
}

class EnvironmentObjectModifier(val target: View, val environmentObject: Any): View() {
    @Composable
    override fun Compose(context: ComposeContext): Unit {
        target.Compose(context.environmentObject(environmentObject))
    }
}

class FixedSizeModifier(val target: View): View() {
    @Composable
    override fun Compose(context: ComposeContext): Unit {
        // TODO: This is probably not working as intended - needs testing
        target.Compose(context.modifier(context.modifier.width(IntrinsicSize.Min).height(IntrinsicSize.Min)))
    }
}

class FontModifier(val target: View, val fontName: String): View() {
    @Composable
    override fun Compose(context: ComposeContext): Unit {
        // TODO: Real font support
        target.Compose(context.environmentObject(fontName))
    }
}

class PaddingModifier(val target: View, val width: Int): View() {
    @Composable
    override fun Compose(context: ComposeContext): Unit {
        target.Compose(context.modifier(context.modifier.padding(all = width.dp)))
    }
}

class SheetModifier(val target: View, val isPresented: Binding<Boolean>, val content: () -> View): View() {
    @OptIn(ExperimentalMaterialApi::class)
    @Composable
    override fun Compose(context: ComposeContext) {
        val targetState = if (isPresented.get()) ModalBottomSheetValue.Expanded else ModalBottomSheetValue.Hidden
        val state = rememberModalBottomSheetState(initialValue = targetState, confirmStateChange = {
            isPresented.set(it != ModalBottomSheetValue.Hidden)
            true
        })

        LaunchedEffect(targetState) {
            state.animateTo(targetState)
        }

        ModalBottomSheetLayout(sheetContent = {
            Box(modifier = Modifier.fillMaxWidth().fillMaxHeight(0.95f), contentAlignment = Alignment.Center) {
                content().Compose(context.push("sheet", Modifier.fillMaxSize()))
            }
        }, sheetState = state) {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                target.Compose(context)
            }
        }
    }
}

val Shapes = Shapes(
    small = RoundedCornerShape(4.dp),
    medium = RoundedCornerShape(4.dp),
    large = RoundedCornerShape(0.dp)
)


val Purple200 = Color(0xFFBB86FC)
val Purple500 = Color(0xFF6200EE)
val Purple700 = Color(0xFF3700B3)
val Teal200 = Color(0xFF03DAC5)


private val DarkColorPalette = darkColors(
    primary = Purple200,
    primaryVariant = Purple700,
    secondary = Teal200
)

private val LightColorPalette = lightColors(
    primary = Purple500,
    primaryVariant = Purple700,
    secondary = Teal200

    // Other default colors to override
    //background = Color.White,
    //surface = Color.White,
    //onPrimary = Color.White,
    //onSecondary = Color.Black,
    //onBackground = Color.Black,
    //onSurface = Color.Black,
)

@Composable
fun SwiftUIComposeTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colors = if (darkTheme) {
        DarkColorPalette
    } else {
        LightColorPalette
    }

    MaterialTheme(
        colors = colors,
        typography = Typography,
        shapes = Shapes,
        content = content
    )
}

// Set of Material typography styles to start with
val Typography = Typography(
    body1 = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp
    )
    // Other default text styles to override
    //button = TextStyle(
    //    fontFamily = FontFamily.Default,
    //    fontWeight = FontWeight.W500,
    //    fontSize = 14.sp
    //),
    //caption = TextStyle(
    //    fontFamily = FontFamily.Default,
    //    fontWeight = FontWeight.Normal,
    //    fontSize = 12.sp
    //)

)
*/
