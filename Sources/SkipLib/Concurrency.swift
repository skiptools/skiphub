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

@frozen public struct Task<Success, Failure> : Sendable where Success : Sendable, Failure : Error {
    public var value: Success { get async throws }

    /// The result or error from a throwing task, after it completes.
    ///
    /// If the task hasn't completed,
    /// accessing this property waits for it to complete
    /// and its priority increases to that of the current task.
    /// Note that this might not be as effective as
    /// creating the task with the correct priority,
    /// depending on the executor's scheduling details.
    ///
    /// - Returns: If the task succeeded,
    ///   `.success` with the task's result as the associated value;
    ///   otherwise, `.failure` with the error as the associated value.
    public var result: Result<Success, Failure> { get async }

    /// Indicates that the task should stop running.
    ///
    /// Task cancellation is cooperative:
    /// a task that supports cancellation
    /// checks whether it has been canceled at various points during its work.
    ///
    /// Calling this method on a task that doesn't support cancellation
    /// has no effect.
    /// Likewise, if the task has already run
    /// past the last point where it would stop early,
    /// calling this method has no effect.
    ///
    /// - SeeAlso: `Task.checkCancellation()`
    public func cancel()

    /// The current task's priority.
    ///
    /// If you access this property outside of any task,
    /// this queries the system to determine the
    /// priority at which the current function is running.
    /// If the system can't provide a priority,
    /// this property's value is `Priority.default`.
    public static var currentPriority: TaskPriority { get }

    /// The current task's base priority.
    ///
    /// If you access this property outside of any task, this returns nil
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    public static var basePriority: TaskPriority? { get }

    @discardableResult
    public init(priority: TaskPriority? = nil, operation: @escaping @Sendable () async throws -> Success)

    @discardableResult
    public static func detached(priority: TaskPriority? = nil, operation: @escaping @Sendable () async -> Success) -> Task<Success, Failure>
    @discardableResult
    public static func detached(priority: TaskPriority? = nil, operation: @escaping @Sendable () async throws -> Success) -> Task<Success, Failure>

    /// Suspends the current task and allows other tasks to execute.
    ///
    /// A task can voluntarily suspend itself
    /// in the middle of a long-running operation
    /// that doesn't contain any suspension points,
    /// to let other tasks run for a while
    /// before execution returns to this task.
    ///
    /// If this task is the highest-priority task in the system,
    /// the executor immediately resumes execution of the same task.
    /// As such,
    /// this method isn't necessarily a way to avoid resource starvation.
    public static func yield() async

    /// A Boolean value that indicates whether the task should stop executing.
    ///
    /// After the value of this property becomes `true`, it remains `true` indefinitely.
    /// There is no way to uncancel a task.
    ///
    /// - SeeAlso: `checkCancellation()`
    public var isCancelled: Bool { get }

    /// A Boolean value that indicates whether the task should stop executing.
    ///
    /// After the value of this property becomes `true`, it remains `true` indefinitely.
    /// There is no way to uncancel a task.
    ///
    /// - SeeAlso: `checkCancellation()`
    public static var isCancelled: Bool { get }

    /// Suspends the current task for at least the given duration
    /// in nanoseconds.
    ///
    /// If the task is canceled before the time ends,
    /// this function throws `CancellationError`.
    ///
    /// This function doesn't block the underlying thread.
    public static func sleep(nanoseconds duration: UInt64) async throws

    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    public static func sleep<C>(until deadline: C.Instant, tolerance: C.Instant.Duration? = nil, clock: C) async throws where C : Clock

    /// Suspends the current task for the given duration on a continuous clock.
    ///
    /// If the task is cancelled before the time ends, this function throws
    /// `CancellationError`.
    ///
    /// This function doesn't block the underlying thread.
    ///
    ///       try await Task.sleep(for: .seconds(3))
    ///
    /// - Parameter duration: The duration to wait.
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    public static func sleep(for duration: Duration) async throws
}

#endif
