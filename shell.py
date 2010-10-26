"""
This module enables easy calls to shell scripts.
"""

import os
import sys

class ShellError(Exception):
    pass

class SshError(Exception):
    pass

class Shell:
    """
    class Shell():
        Provides methods to access shell using standard patterns.
	In particular, the call() method throws an exception if the shell statement exits with a non-zero status.
	Use:
		- call() if you are interested in the result returned in stdout.
		- test() to get a True/False value from a shell expression (bash/python true/false are inverted).
		- system() to get standard os.system like interface.
    """
    def __init__(self, echo=False):
        self.echo=echo

    def call(self, command):
        """
        Shell.call(command) --> output, raises ShellError
            Executes the given command, and returns the stdout output as a string.
	    If the command terminates with a non-zero status a shell exception is raised.

	    The nice part of this is the inverse is also true.  If an exception escapes a python
	    program, the interpreter will return a non-zero result to shell.
        """
        result,output=self.raw_call(command)
        if result:
	    if not isinstance(self, Ssh):
                raise ShellError(command, result, output)
            else:
                raise ShellError(self.ssh_command(command), result, output)
        return output

    def test(self, command):
        """
	Shell.test(command) --> bool
	    The return result of the command is interpreted as a boolean.  
	    In bash, 0 is true, anything else is false.  In Python, Zero and None are false, everything else is True"
	"""
    	return not os.system(command)

    def system(self, command):
        """
	Shell.system(command):
	    Has the exact same semantics as os.system(command).  Use this if you are only interested in the return
	    result of the command.  If the result is meant to indiciate an error, use call().
	"""
    	return os.system(command)

    def raw_call(self, command):
        """
	raw_call(command) --> (result, output)

               Runs the command in the local shell returning a tuple 
	       containing :
	           - the return result (None for 0, otherwise an int), and
	           - the full, stripped standard output.

	       You wouldn't normally use this, instead consider call(), test() and system()
	"""
        process=os.popen(command)
	output=[]
	line=process.readline()
	while not line=="":
	    if self.echo:
	        print line,
                sys.stdout.flush()
	    output.append(line)
	    line=process.readline()
        result=process.close()

        return (result, "".join(output).strip())

class Ssh(Shell):
    """
    class Ssh(id, gateway=None, echo=False) is a Shell:
       Provides a remote shell interface over ssh.  After the Ssh object is
       created it can be treated identically to a Shell object.

       To create an Ssh object, set the id as the target machine or user.  For example:
           remote=shell.Ssh("uluru"), or
	   remote=shell.Ssh("bburns@uluru")

       You can also provide another Ssh object as a gateway in order to obtain access to the target id.
    """
    def __init__(self, id, gateway=None, echo=False, options=""):
	self.ssh_prog="ssh"
	self.id=id
	self.ssh_cmd="%s %s %s" % (self.ssh_prog, options, id)
	self.gateway=gateway
	self.echo=echo
	self.check()

    def call(self, command):
        """
	See Shell.call()
	"""
        return Shell.call(self, command)

    def test(self, command):
        """
	See Shell.test
	"""
        return Shell.test(self, self.ssh_command(command))

    def system(self, command):
        """
	See Shell.system
	"""
        return Shell.system(self, self.ssh_command(command))

    def raw_call(self, command):
        """
	See Shell.raw_call
	"""
	return Shell.raw_call(self, self.ssh_command(command))

    def check(self):
    	"""
	Ssh.check():
            Used during initialisation to check that the connection works.
	"""
    	try:
	    checkString="Checking SSH Connection to %s" % self.id
	    x = self
	    while x.gateway:
	        checkString="%s via %s" % (checkString, x.gateway.id)
		x = x.gateway
    	    assert(self.call('echo "%s"' % checkString)==checkString)
	except ShellError, inst:
		raise SshError(inst.args)

    def escapeSshString(self, escaped):
        escaped=escaped.replace("\\", "\\\\")
	escaped=escaped.replace("$", "\\$")
	escaped=escaped.replace('"', '\\"')
	return escaped

    def ssh_command(self, command):
        """
	    Ssh.ssh_command(): Converts the normal shell command into a ssh command
	"""
        escaped=self.escapeSshString(command)
	cmd='%s "%s"' % ( self.ssh_cmd, escaped )
	if self.gateway:
	    cmd=self.gateway.ssh_command(cmd)
	# print "cmd:", cmd
	return cmd

# arch-tag: Ben Burns 25-11-2003 00:14 shell.py
