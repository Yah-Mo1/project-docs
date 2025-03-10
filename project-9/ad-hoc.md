What are ad hoc commands?
Ad-hoc commands are one-line linux shell commands that perform a specif task on one or more managed nodes.
The ping module is an ad-hoc command because we use it to send a ping request to all the nodes defined within the hosts filed
If we dotn specify a module in ansible, the task will fail because ansible needs a module to execute a specific action on a remote host --> Without a module, it doesnt know what to do and will just throw an error indicating that a module is required.

Disadvatages and advantages of using the command module:
