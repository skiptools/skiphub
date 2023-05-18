// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// THIS TRANSPILATION IS NOT USED
//
// This file only exists to provide symbols for implemented API to the transpiler.
//

#if SKIP

public struct Task<Success, Failure> where Failure: Error {
    // Note: This is special cased in the transpiler to suspend function value()
    // SKIP NOWARN
    public var value: Success {
        get async throws {
            fatalError()
        }
    }

    // SKIP NOWARN
    @available(*, unavailable)
    public var result: Result<Success, Failure> {
        get async {
            fatalError()
        }
    }

    @available(*, unavailable)
    public func cancel() {
        fatalError()
    }

    @available(*, unavailable)
    public static var currentPriority: TaskPriority {
        fatalError()
    }

    @available(*, unavailable)
    public static var basePriority: TaskPriority? {
        fatalError()
    }

    public init(priority: TaskPriority? = nil, operation: @escaping () async throws -> Success) {
        fatalError()
    }

    // SKIP NOWARN
    public static func detached(priority: TaskPriority? = nil, operation: @escaping () async -> Success) -> Task<Success, Failure> {
        fatalError()
    }

    @available(*, unavailable)
    public static func yield() async {
        fatalError()
    }

    @available(*, unavailable)
    public var isCancelled: Bool {
        fatalError()
    }

    @available(*, unavailable)
    public static var isCancelled: Bool {
        fatalError()
    }

    @available(*, unavailable)
    public static func checkCancellation() throws {
        fatalError()
    }

    @available(*, unavailable)
    public static func sleep(nanoseconds duration: UInt64) async throws {
        fatalError()
    }

    // public static func sleep<C>(until deadline: C.Instant, tolerance: C.Instant.Duration? = nil, clock: C) async throws where C : Clock
    @available(*, unavailable)
    public static func sleep(until deadline: Any, tolerance: Any? = nil, clock: Any) async throws {
        fatalError()
    }

    @available(*, unavailable)
    public static func sleep(for duration: /* Duration */ Double) async throws {
        fatalError()
    }
}

@available(*, unavailable)
public struct TaskGroup<ChildTaskResult> {
}

public struct TaskPriority : RawRepresentable {
    public var rawValue: /* UInt8 */ Int {
        fatalError()
    }

    public init(rawValue: /* UInt8 */ Int) {
        fatalError()
    }

    public static var high: TaskPriority {
        fatalError()
    }
    public static var medium: TaskPriority {
        fatalError()
    }
    public static var low: TaskPriority {
        fatalError()
    }
    public static var userInitiated: TaskPriority {
        fatalError()
    }
    public static var utility: TaskPriority {
        fatalError()
    }
    public static var background: TaskPriority {
        fatalError()
    }
}

@available(*, unavailable)
public struct ThrowingTaskGroup<ChildTaskResult, Failure> where Failure : Error {
}


@available(*, unavailable)
public struct UnownedJob {
}

@available(*, unavailable)
public struct UnownedSerialExecutor {
}

@available(*, unavailable)
public struct UnsafeContinuation<T, E> where E : Error {
}

@available(*, unavailable)
public struct UnsafeCurrentTask {
}

@available(*, unavailable)
public func withCheckedContinuation<T>(function: String = "", _ body: (CheckedContinuation<T, Never>) -> Void) async -> T {
    fatalError()
}

@available(*, unavailable)
@inlinable public func withCheckedThrowingContinuation<T>(function: String = "", _ body: (CheckedContinuation<T, Error>) -> Void) async throws -> T {
    fatalError()
}

@available(*, unavailable)
public func withTaskCancellationHandler<T>(operation: () async throws -> T, onCancel handler: () -> Void) async rethrows -> T {
    fatalError()
}

@available(*, unavailable)
public func withTaskGroup<ChildTaskResult, GroupResult>(of childTaskResultType: ChildTaskResult.Type, returning returnType: GroupResult.Type = GroupResult.self, body: (inout TaskGroup<ChildTaskResult>) async -> GroupResult) async -> GroupResult {
    fatalError()
}

@available(*, unavailable)
@inlinable public func withThrowingTaskGroup<ChildTaskResult, GroupResult>(of childTaskResultType: ChildTaskResult.Type, returning returnType: GroupResult.Type = GroupResult.self, body: (inout ThrowingTaskGroup<ChildTaskResult, Error>) async throws -> GroupResult) async rethrows -> GroupResult {
    fatalError()
}

@available(*, unavailable)
public func withUnsafeContinuation<T>(_ fn: (UnsafeContinuation<T, Never>) -> Void) async -> T {
    fatalError()
}

@available(*, unavailable)
public func withUnsafeCurrentTask<T>(body: (UnsafeCurrentTask?) throws -> T) rethrows -> T {
    fatalError()
}

@available(*, unavailable)
public func withUnsafeThrowingContinuation<T>(_ fn: (UnsafeContinuation<T, Error>) -> Void) async throws -> T {
    fatalError()
}

#endif
