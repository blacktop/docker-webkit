import lldb
from lldb_dump_class_layout import ClassLayout


def __lldb_init_module(debugger, internal_dict):
    debugger.HandleCommand("command script add -f classdump.dumpclass cdump")


def dumpclass(debugger, command, result, internal_dict):
    target = debugger.GetSelectedTarget()
    module = target.GetModuleAtIndex(0)
    types = module.FindTypes(command)
    ClassLayout(target, types.GetTypeAtIndex(0)).dump()
