Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$stopCodes = @(
    @{ Code = "DRIVER_IRQL_NOT_LESS_OR_EQUAL (0xD1)"; Failed = "myfault.sys" },
    @{ Code = "IRQL_NOT_LESS_OR_EQUAL (0x0A)"; Failed = "ntoskrnl.exe" },
    @{ Code = "PAGE_FAULT_IN_NONPAGED_AREA (0x50)"; Failed = "ntoskrnl.exe" },
    @{ Code = "CRITICAL_PROCESS_DIED (0xEF)"; Failed = "" },
    @{ Code = "SYSTEM_SERVICE_EXCEPTION (0x3B)"; Failed = "win32kfull.sys" },
    @{ Code = "KMODE_EXCEPTION_NOT_HANDLED (0x1E)"; Failed = "wdf01000.sys" },
    @{ Code = "DPC_WATCHDOG_VIOLATION (0x133)"; Failed = "nvlddmkm.sys" },
    @{ Code = "WHEA_UNCORRECTABLE_ERROR (0x124)"; Failed = "hal.dll" },
    @{ Code = "MEMORY_MANAGEMENT (0x1A)"; Failed = "" },
    @{ Code = "KERNEL_DATA_INPAGE_ERROR (0x7A)"; Failed = "disk.sys" },
    @{ Code = "BAD_POOL_CALLER (0xC2)"; Failed = "ntfs.sys" },
    @{ Code = "MACHINE_CHECK_EXCEPTION (0x9C)"; Failed = "" },
    @{ Code = "VIDEO_TDR_FAILURE (0x116)"; Failed = "nvlddmkm.sys" },
    @{ Code = "ATTEMPTED_WRITE_TO_READONLY_MEMORY (0xBE)"; Failed = "ntoskrnl.exe" },
    @{ Code = "SYSTEM_THREAD_EXCEPTION_NOT_HANDLED (0x7E)"; Failed = "dxgkrnl.sys" },
    @{ Code = "KERNEL_SECURITY_CHECK_FAILURE (0x139)"; Failed = "" },
    @{ Code = "DRIVER_IRQL_NOT_LESS_OR_EQUAL (0xD1)"; Failed = "ndis.sys" },
    @{ Code = "INACCESSIBLE_BOOT_DEVICE (0x7B)"; Failed = "storport.sys" },
    @{ Code = "NTFS_FILE_SYSTEM (0x24)"; Failed = "ntfs.sys" },
    @{ Code = "KERNEL_MODE_HEAP_CORRUPTION (0x13A)"; Failed = "ntoskrnl.exe" },
    @{ Code = "POOL_CORRUPTION_IN_FILE_AREA (0x2C)"; Failed = "ntfs.sys" },
    @{ Code = "IRQL_GT_ZERO_AT_SYSTEM_SERVICE (0x4A)"; Failed = "ntoskrnl.exe" },
    @{ Code = "WORKER_INVALID (0xE4)"; Failed = "ntoskrnl.exe" },
    @{ Code = "APC_INDEX_MISMATCH (0x01)"; Failed = "ntoskrnl.exe" },
    @{ Code = "DRIVER_OVERRAN_STACK_BUFFER (0xF7)"; Failed = "ntoskrnl.exe" },
    @{ Code = "BUGCODE_USB_DRIVER (0xFE)"; Failed = "usbhub.sys" },
    @{ Code = "UNEXPECTED_STORE_EXCEPTION (0x154)"; Failed = "" },
    @{ Code = "CRITICAL_STRUCTURE_CORRUPTION (0x109)"; Failed = "ntoskrnl.exe" },
    @{ Code = "CLOCK_WATCHDOG_TIMEOUT (0x101)"; Failed = "intelppm.sys" },
    @{ Code = "PFN_LIST_CORRUPT (0x4E)"; Failed = "ntoskrnl.exe" },
    @{ Code = "DRIVER_POWER_STATE_FAILURE (0x9F)"; Failed = "ntoskrnl.exe" },
    @{ Code = "THREAD_STUCK_IN_DEVICE_DRIVER (0xEA)"; Failed = "dxgkrnl.sys" },
    @{ Code = "REGISTRY_ERROR (0x51)"; Failed = "" },
    @{ Code = "STATUS_SYSTEM_PROCESS_TERMINATED (0xC000021A)"; Failed = "ntdll.dll" },
    @{ Code = "HAL_INITIALIZATION_FAILED (0x5C)"; Failed = "hal.dll" },
    @{ Code = "VIDEO_TDR_TIMEOUT_DETECTED (0x117)"; Failed = "nvlddmkm.sys" },
    @{ Code = "MANUALLY_INITIATED_CRASH (0xE2)"; Failed = "kbdclass.sys" },
    @{ Code = "FAT_FILE_SYSTEM (0x23)"; Failed = "fastfat.sys" },
    @{ Code = "DRIVER_VERIFIER_DETECTED_VIOLATION (0xC4)"; Failed = "verifier.sys" },
    @{ Code = "BUGCODE_NDIS_DRIVER (0x7C)"; Failed = "ndis.sys" },
    @{ Code = "ACPI_BIOS_ERROR (0xA5)"; Failed = "acpi.sys" },
    @{ Code = "FLTMGR_FILE_SYSTEM (0xF5)"; Failed = "fltmgr.sys" },
    @{ Code = "PCI_BUS_DRIVER_INTERNAL (0xA1)"; Failed = "pci.sys" },
    @{ Code = "WDF_VIOLATION (0x10D)"; Failed = "Wdf01000.sys" },
    @{ Code = "NMI_HARDWARE_FAILURE (0x80)"; Failed = "" },
    @{ Code = "REFS_FILE_SYSTEM (0x149)"; Failed = "ReFS.sys" },
    @{ Code = "KERNEL_AUTO_BOOST_LOCK_ACQUISITION_WITH_RAISED_IRQL (0x192)"; Failed = "ntoskrnl.exe" },
    @{ Code = "UDFS_FILE_SYSTEM (0x26)"; Failed = "udfs.sys" },
    @{ Code = "VIDEO_ENGINE_TIMEOUT_DETECTED (0x141)"; Failed = "watchdog.sys" },
    @{ Code = "NDIS_INTERNAL_ERROR (0xB8)"; Failed = "ndis.sys" },
    @{ Code = "PAGE_FAULT_IN_FREED_SPECIAL_POOL (0xCC)"; Failed = "ntoskrnl.exe" },
    @{ Code = "KERNEL_AUTO_BOOST_INVALID_LOCK_RELEASE (0x162)"; Failed = "ntoskrnl.exe" },
    @{ Code = "UNHANDLED_EXCEPTION_CONTEXT (0x1CC)"; Failed = "" },
    @{ Code = "EXFAT_FILE_SYSTEM (0x12C)"; Failed = "exfat.sys" },
    @{ Code = "KERNEL_STACK_INPAGE_ERROR (0x77)"; Failed = "ntoskrnl.exe" },
    @{ Code = "DATA_BUS_ERROR (0x2E)"; Failed = "" },
    @{ Code = "NO_MORE_SYSTEM_PTES (0x3F)"; Failed = "" },
    @{ Code = "TARGET_MDL_TOO_SMALL (0x40)"; Failed = "" },
    @{ Code = "MUST_SUCCEED_POOL_EMPTY (0x41)"; Failed = "" },
    @{ Code = "ATTEMPTED_SWITCH_FROM_DPC (0xB8)"; Failed = "ntoskrnl.exe" },
    @{ Code = "MUTUALLY_EXCLUSIVE_RESOURCE_MUST_BE_LONG_TERM (0xC1)"; Failed = "" },
    @{ Code = "DRIVER_LEFT_LOCKED_PAGES_IN_PROCESS (0xCB)"; Failed = "" },
    @{ Code = "TERMINAL_SERVER_DRIVER_MADE_INCORRECT_MEMORY_REFERENCE (0xCF)"; Failed = "rdpdr.sys" },
    @{ Code = "DRIVER_UNLOADED_WITHOUT_CANCELLING_PENDING_OPERATIONS (0xCE)"; Failed = "" },
    @{ Code = "SYSTEM_SCAN_AT_RAISED_IRQL_CAUGHT_IMPROPER_DRIVER_UNLOAD (0xD4)"; Failed = "" },
    @{ Code = "DRIVER_PORTION_MUST_BE_NONPAGED (0xD3)"; Failed = "" },
    @{ Code = "VIDEO_DRIVER_INIT_FAILURE (0xB4)"; Failed = "vgapnp.sys" },
    @{ Code = "BOOTLOG_FILE_SYSTEM (0xB7)"; Failed = "" },
    @{ Code = "AGP_INVALID_ACCESS (0x104)"; Failed = "videoprt.sys" },
    @{ Code = "AGP_GART_CORRUPTION (0x105)"; Failed = "videoprt.sys" },
    @{ Code = "AGP_ILLEGAL_GART_ACCESS (0x106)"; Failed = "videoprt.sys" },
    @{ Code = "FTDISK_INTERNAL_ERROR (0x58)"; Failed = "ftdisk.sys" },
    @{ Code = "PINBALL_FILE_SYSTEM (0x59)"; Failed = "pinball.sys" },
    @{ Code = "CRITICAL_SERVICE_FAILED (0x5A)"; Failed = "" },
    @{ Code = "SET_ENV_VAR_FAILED (0x61)"; Failed = "" },
    @{ Code = "IO1_INITIALIZATION_FAILED (0x69)"; Failed = "" },
    @{ Code = "PROCESS1_INITIALIZATION_FAILED (0x6B)"; Failed = "" },
    @{ Code = "REF_LM_DEBUG_STRING (0x72)"; Failed = "" },
    @{ Code = "SESSION3_INITIALIZATION_FAILED (0x6F)"; Failed = "smss.exe" },
    @{ Code = "CONFIG_INITIALIZATION_FAILED (0x67)"; Failed = "" },
    @{ Code = "CONFIG_LIST_FAILED (0x73)"; Failed = "" },
    @{ Code = "BAD_SYSTEM_CONFIG_INFO (0x74)"; Failed = "" },
    @{ Code = "CANNOT_WRITE_CONFIGURATION (0x75)"; Failed = "" },
    @{ Code = "PROCESS_HAS_LOCKED_PAGES (0x76)"; Failed = "" },
    @{ Code = "PHASE0_EXCEPTION (0x78)"; Failed = "" },
    @{ Code = "MISMATCHED_HAL (0x79)"; Failed = "hal.dll" },
    @{ Code = "INSTALL_MORE_MEMORY (0x7D)"; Failed = "" },
    @{ Code = "SYSTEM_EXIT_OWNED_MUTEX (0x39)"; Failed = "" },
    @{ Code = "MULTIPROCESSOR_CONFIGURATION_NOT_SUPPORTED (0x3E)"; Failed = "" },
    @{ Code = "UNEXPECTED_KERNEL_MODE_TRAP (0x7F)"; Failed = "ntoskrnl.exe" },
    @{ Code = "NDISTEST_INTERNAL_ERROR (0xBB)"; Failed = "ndis.sys" },
    @{ Code = "SPECIAL_POOL_DETECTED_MEMORY_CORRUPTION (0xC1)"; Failed = "ntoskrnl.exe" },
    @{ Code = "DRIVER_CORRUPTED_EXPOOL (0xC5)"; Failed = "" },
    @{ Code = "DRIVER_CORRUPTED_MMPOOL (0xD0)"; Failed = "" },
    @{ Code = "DRIVER_USED_EXCESSIVE_PTES (0xD5)"; Failed = "" },
    @{ Code = "DRIVER_INVALID_STACK_ACCESS (0xDC)"; Failed = "" },
    @{ Code = "CHR_INTERNAL_ERROR (0xE1)"; Failed = "" },
    @{ Code = "RESOURCE_NOT_OWNED (0xE3)"; Failed = "" },
    @{ Code = "CANCEL_STATE_IN_COMPLETED_IRP (0xE8)"; Failed = "" },
    @{ Code = "SYSTEM_THREAD_NOT_GRANTED_ACCESS (0xEA)"; Failed = "" },
    @{ Code = "DRIVER_RETURNED_STATUS_REPARSE_FOR_VOLUME_OPEN (0xED)"; Failed = "" },
    @{ Code = "HTTP_DRIVER_CORRUPTED (0xFA)"; Failed = "http.sys" },
    @{ Code = "SECURE_KERNEL_ERROR (0x165)"; Failed = "" },
    @{ Code = "HYPERVISOR_ERROR (0x20001)"; Failed = "hvix64.sys" },
    @{ Code = "WINLOGON_FATAL_ERROR (0xC000021A)"; Failed = "winlogon.exe" },
    @{ Code = "DRIVER_RETURNED_HOLDING_LOCK (0xDE)"; Failed = "" },
    @{ Code = "KERNEL_THREAD_PRIORITY_FLOOR_VIOLATION (0x15D)"; Failed = "ntoskrnl.exe" },
    @{ Code = "VIDEO_SCHEDULER_INTERNAL_ERROR (0x119)"; Failed = "dxgmms2.sys" },
    @{ Code = "ATTEMPTED_EXECUTE_OF_NOEXECUTE_MEMORY (0xFC)"; Failed = "ntoskrnl.exe" }
)

if (-not $StopCode) {
    $errorChoice = $stopCodes | Get-Random
    $StopCode = $errorChoice.Code
    if (-not $PSBoundParameters.ContainsKey('WhatFailed')) {
        $WhatFailed = $errorChoice.Failed
    }
}

$form = [System.Windows.Forms.Form]::new()
$form.BackColor = [System.Drawing.Color]::Black
$form.FormBorderStyle = 'None'
$form.WindowState = 'Maximized'
$form.TopMost = $true
$form.Cursor = [System.Windows.Forms.Cursors]::None
$form.Add_Shown({ [System.Windows.Forms.Cursor]::Hide() })

$form.Add_KeyDown({ if ($_.KeyCode -eq 'Escape') { Stop-Process -Id $PID -Force } })

[int]$w = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
[int]$h = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
if ($w -eq 0) { $w = 1920 }; if ($h -eq 0) { $h = 1080 }
$scaleY = $h / 1080

$mainFontSize = [int](26 * $scaleY)
$subFontSize = [int](22 * $scaleY)
$infoFontSize = [int](16 * $scaleY)

$lblMain = [System.Windows.Forms.Label]::new()
$lblMain.Text = "Your device ran into a problem and needs to restart."
$lblMain.Font = [System.Drawing.Font]::new("Segoe UI Semilight", $mainFontSize)
$lblMain.ForeColor = [System.Drawing.Color]::White
$lblMain.AutoSize = $false
$lblMain.Size = [System.Drawing.Size]::new($w, [int](60 * $scaleY))
$lblMain.Location = [System.Drawing.Point]::new(0, [int]($h * 0.45))
$lblMain.TextAlign = 'MiddleCenter'
$form.Controls.Add($lblMain)

$lblPct = [System.Windows.Forms.Label]::new()
$lblPct.Text = "0% complete"
$lblPct.Font = [System.Drawing.Font]::new("Segoe UI Semilight", $subFontSize)
$lblPct.ForeColor = [System.Drawing.Color]::White
$lblPct.AutoSize = $false
$lblPct.Size = [System.Drawing.Size]::new($w, [int](50 * $scaleY))
$lblPct.Location = [System.Drawing.Point]::new(0, [int]($h * 0.53))
$lblPct.TextAlign = 'MiddleCenter'
$form.Controls.Add($lblPct)

$stopCodeY = if ($WhatFailed) { [int]($h * 0.88) } else { [int]($h * 0.90) }

$lblStopCode = [System.Windows.Forms.Label]::new()
$lblStopCode.Text = "Stop code: $StopCode"
$lblStopCode.Font = [System.Drawing.Font]::new("Segoe UI Light", $infoFontSize)
$lblStopCode.ForeColor = [System.Drawing.Color]::White
$lblStopCode.AutoSize = $false
$lblStopCode.Size = [System.Drawing.Size]::new($w, [int](35 * $scaleY))
$lblStopCode.Location = [System.Drawing.Point]::new(0, $stopCodeY)
$lblStopCode.TextAlign = 'MiddleCenter'
$form.Controls.Add($lblStopCode)

if ($WhatFailed) {
    $lblFailed = [System.Windows.Forms.Label]::new()
    $lblFailed.Text = "What failed: $WhatFailed"
    $lblFailed.Font = [System.Drawing.Font]::new("Segoe UI Light", $infoFontSize)
    $lblFailed.ForeColor = [System.Drawing.Color]::White
    $lblFailed.AutoSize = $false
    $lblFailed.Size = [System.Drawing.Size]::new($w, [int](35 * $scaleY))
    $lblFailed.Location = [System.Drawing.Point]::new(0, [int]($h * 0.92))
    $lblFailed.TextAlign = 'MiddleCenter'
    $form.Controls.Add($lblFailed)
}

$timer = [System.Windows.Forms.Timer]::new()
$timer.Interval = 1500
$script:pct = 0
$timer.Add_Tick({
    $script:pct += (Get-Random -Min 8 -Max 22)
    if ($script:pct -ge 100) { 
        $script:pct = 100
        $lblPct.Text = "100% complete"
        $timer.Stop()
        
        $form.Controls.Clear()
        $form.BackColor = [System.Drawing.Color]::Black
        $form.Refresh()
        
        Start-Sleep -Seconds 5
        Stop-Process -Id $PID -Force
    } else {
        $lblPct.Text = "$script:pct% complete"
    }
})

$timer.Start()
[void]$form.ShowDialog()
