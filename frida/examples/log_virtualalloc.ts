// <reference types=frida-gum />

namespace Flags {
    export enum ProtectionFlags {
        PAGE_NOACCESS = 0x01,
        PAGE_READONLY = 0x02,
        PAGE_READWRITE = 0x04,
        PAGE_WRITECOPY = 0x08,
        PAGE_EXECUTE = 0x10,
        PAGE_EXECUTE_READ = 0x20,
        PAGE_EXECUTE_READWRITE = 0x40,
        PAGE_EXECUTE_WRITECOPY = 0x80,
        PAGE_GUARD = 0x100,
        PAGE_NOCACHE = 0x200,
        PAGE_WRITECOMBINE = 0x400
    }

    export enum AllocationTypeFlags {
        MEM_COMMIT = 0x00001000,
        MEM_RESERVE = 0x00002000,
        MEM_RESET = 0x00080000,
        MEM_TOP_DOWN = 0x00100000,
        MEM_WRITE_WATCH = 0x00200000,
        MEM_PHYSICAL = 0x00400000,
        MEM_RESET_UNDO = 0x1000000,
        MEM_LARGE_PAGES = 0x20000000
    }
}

function decodeFlags(value: number, flagEnum: { [key: string]: number | string }): string {
    const matchedFlags: string[] = [];

    for (const [flagName, flagValue] of Object.entries(flagEnum)) {
        if (typeof flagValue === 'number' && (value & flagValue) === flagValue) {
            matchedFlags.push(flagName);
        }
    }

    return matchedFlags.length > 0 ? matchedFlags.join(" | ") : `0x${value.toString(16)}`;
}

interface WinAPIFunctions {
    VirtualAlloc: NativePointer;
}

function getFunctionAddresses(): WinAPIFunctions {
    const kernel32 = Process.getModuleByName('kernel32.dll');

    return {
        VirtualAlloc: kernel32.findExportByName("VirtualAlloc") ?? (() => { throw new Error("[-] Failed to find VirtualAlloc"); })()
    }
}

function interceptFunctions(functions: WinAPIFunctions): void {
    Interceptor.attach(functions.VirtualAlloc, {
        onEnter: function (args) {
            const lpAddress: NativePointer = args[0];            // LPVOID lpAddress
            const dwSize: number           = args[1].toInt32();  // SIZE_T dwSize
            const flAllocationType: number = args[2].toInt32();  // DWORD flAllocationType
            const flProtect: number        = args[3].toInt32();  // DWORD flProtect

            console.log(`\n[*] kernel32!VirtualAlloc - Allocating at ${lpAddress.toString()} with size 0x${dwSize.toString(16)}.` + 
                `Allocation: ${decodeFlags(flAllocationType, Flags.AllocationTypeFlags)}, ` + 
                `Protection: ${decodeFlags(flProtect, Flags.ProtectionFlags)}`);
        },
        onLeave: function (retval: NativePointer) {
            console.log(`[*] VirtualAlloc returned: ${retval.toString()}`);
        }
    });
}

function main(): void {
    const functions: WinAPIFunctions = getFunctionAddresses();
    interceptFunctions(functions)
}

main();
