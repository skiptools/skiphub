
#if os(macOS) || os(Linux)
/// Command-line runner for the transpiler.
@available(macOS 13, macCatalyst 16, *)
@available(iOS, unavailable, message: "Gradle tests can only be run on macOS")
@available(watchOS, unavailable, message: "Gradle tests can only be run on macOS")
@available(tvOS, unavailable, message: "Gradle tests can only be run on macOS")
@main public struct SkipDroid {
    static func main() async throws {
        //await SkipCommandExecutor.main()
        print("TBD: launch the gradle app")
    }
}
#endif
