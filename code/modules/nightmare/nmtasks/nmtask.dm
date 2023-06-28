/// Nightmare task, executing game actions as part of context
/datum/nmtask
	/// Task name
	var/name = "abstract task"
	/// Task behavior flags
	var/nightmare_flags = NIGHTMARE_TASKFLAG_ONESHOT

/datum/nmtask/New(name)
	. = ..()
	if(name)
		src.name = name

/// Free resources used by the task and its state, without deleting it
/datum/nmtask/proc/cleanup()
	return

/// Task implementation
/datum/nmtask/proc/execute()
	PROTECTED_PROC(TRUE)
	return NIGHTMARE_TASK_OK

/// Invoke task execution synchronously
/datum/nmtask/proc/invoke_sync()
	SHOULD_NOT_OVERRIDE(TRUE)
	if(nightmare_flags & NIGHTMARE_TASKFLAG_DISABLED)
		return NIGHTMARE_TASK_ERROR
	if(nightmare_flags & NIGHTMARE_TASKFLAG_ONESHOT)
		nightmare_flags |= NIGHTMARE_TASKFLAG_DISABLED
	. = NIGHTMARE_TASK_ASYNC // Feedback & Safety
	. = execute()

/// Internal wrapper for async exec
/datum/nmtask/proc/_invoke_async(datum/callback/async_callback)
	PRIVATE_PROC(TRUE)
	. = invoke_sync()
	async_callback?.Invoke(.)

/// Invoke task execution asynchronously
/// If the return value is anything else than NIGHTMARE_TASK_ASYNC,
/// the task will have completed, and callback fired, before this proc returns
/datum/nmtask/proc/invoke_async(datum/callback/async_callback)
	SHOULD_NOT_OVERRIDE(TRUE)
	set waitfor = FALSE
	. = _invoke_async(async_callback)
