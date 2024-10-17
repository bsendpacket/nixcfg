// <reference types=frida-gum />

// Constants
const protectionFlags: { [key: number]: string } = {
    0x01: "PAGE_NOACCESS",
    0x02: "PAGE_READONLY",
    0x04: "PAGE_READWRITE",
    0x08: "PAGE_WRITECOPY",
    0x10: "PAGE_EXECUTE",
    0x20: "PAGE_EXECUTE_READ",
    0x40: "PAGE_EXECUTE_READWRITE",
    0x80: "PAGE_EXECUTE_WRITECOPY",
    0x100: "PAGE_GUARD",
    0x200: "PAGE_NOCACHE",
    0x400: "PAGE_WRITECOMBINE"
};

const allocationTypeFlags: { [key: number]: string } = {
    0x00001000: "MEM_COMMIT",
    0x00002000: "MEM_RESERVE",
    0x00080000: "MEM_RESET",
    0x00100000: "MEM_TOP_DOWN",
    0x00200000: "MEM_WRITE_WATCH",
    0x00400000: "MEM_PHYSICAL",
    0x1000000: "MEM_RESET_UNDO",
    0x20000000: "MEM_LARGE_PAGES"
};

// Helper to decode flags in cases where they are combinations
function decodeFlags(value: number, flagMap: { [key: number]: string }): string {
    const result: string[] = [];
    
    // Iterate through the flagMap to check which flags are set
    for (const flag in flagMap) {
        const flagValue = parseInt(flag, 10);

        // Add matched flag to the results
        if ((value & flagValue) === flagValue) {
            result.push(flagMap[flagValue]);
        }
    }
    
    // Not a known flag...
    if (result.length === 0) {
        result.push(`0x${value.toString(16)}`);
    }
    
    return result.join(" | ");
}

// Retrieve Functions
const VirtualAlloc = Module.findExportByName('kernel32.dll', 'VirtualAlloc');
if (VirtualAlloc === null) {
    throw new Error('[-] VirtualAlloc not found');
} else {
    console.log("[+] VirtualAlloc found!");
}

Interceptor.attach(VirtualAlloc, {
    onEnter: function (args) {
        const lpAddress = args[0];                      // LPVOID lpAddress
        const dwSize = args[1].toInt32();               // SIZE_T dwSize
        const flAllocationType = args[2].toInt32();     // DWORD flAllocationType
        const flProtect = args[3].toInt32();            // DWORD flProtect

        console.log("");
        console.log(`[*] kernel32!VirtualAlloc - Allocating at ${lpAddress.toString()} with size 0x${dwSize.toString(16)}. Allocation: ${decodeFlags(flAllocationType, allocationTypeFlags)}, Protection: ${decodeFlags(flProtect, protectionFlags)}`);
    },
    onLeave: function (retval: NativePointer) {
        console.log(`[*] VirtualAlloc returned: ${retval.toString()}`);
    }
});
