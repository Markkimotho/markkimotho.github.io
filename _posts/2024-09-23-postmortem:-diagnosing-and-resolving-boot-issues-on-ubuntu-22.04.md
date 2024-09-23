---
layout: post
title: "Postmortem: Resolving Black Screen Boot Issues on Ubuntu 22.04"
date: 2024-09-23
tags: [postmortem, ubuntu, black screen]
---

## Postmortem: Resolving Black Screen Boot Issues on Ubuntu 22.04

<p align="center">
  <img src="/images/tech-fails.gif" alt="Tech Failures">
</p>

## Issue Summary

On June 9, 2023, between 11:05 AM and 1:40 PM EAT, my Ubuntu 22.04 laptop experienced a critical boot issue, launching to a terminal without a graphical user interface (GUI). This disruption significantly affected my workflow, confining all tasks to the command line.

## Timeline of Events

**Note: All times are in EAT**

### 11:05 AM - 11:20 AM

<p align="center">
  <img src="/images/sys_restart.jpg" alt="System Restart">
</p>

- **Description:** Attempted multiple restarts to regain GUI access.
- **Outcome:** Each attempt led to a terminal display.

### 11:20 AM - 11:30 AM

- **Description:** Executed a system update and package upgrade.
- **Outcome:** Update and upgrade completed successfully, but the issue remained.

### 11:30 AM - 11:40 AM

- **Description:** Checked log files (`/var/log/syslog`) for root cause analysis.
- **Outcome:** Identified a problem with the Light Display Manager; none was available.

### 11:40 AM - 12:00 PM

- **Description:** Installed the LightDM display manager as a potential fix.
- **Outcome:** The issue persisted, indicating that LightDM was not the solution.

### 12:00 PM - 1:20 PM

- **Description:** Reviewed log files to determine the default display manager.
- **Outcome:** Confirmed GDM (GNOME Display Manager) was set as the default.

### 1:20 PM - 1:30 PM

- **Description:** Reinstalled the broken GDM3 (GNOME Display Manager).
- **Outcome:** Successfully reinitialized the system and regained GUI access.

### 1:30 PM - 1:40 PM

- **Description:** Reinstalled the `ubuntu-desktop` package to restore the desktop environment.
- **Outcome:** GUI displayed successfully.

## Root Cause

The primary cause of the boot issue was the absence of a compatible display manager, which stemmed from the forced installation of an incompatible package on the previous day. This led to dependency conflicts and package version mismatches that disrupted display-related functionalities.

## Resolution Steps

To resolve the boot issue and restore the graphical interface, I followed these steps:

1. **Rollback Incompatible Packages:**
   - Use a package manager to revert installations of problematic packages like `libglapi-mesa` and `libegl1-mesa0` to compatible versions.

2. **Update System:**
   - Run a system update and upgrade to ensure all packages are current:
     ```bash
     sudo apt update
     sudo apt upgrade
     ```

3. **Install or Reinstall Display Managers:**
   - Attempt to install a different display manager (e.g., LightDM) to troubleshoot. If unsuccessful, reinstall the default display manager:
     ```bash
     sudo apt install --reinstall gdm3
     ```

4. **Reinitialize the System:**
   - Restart your laptop to apply changes:
     ```bash
     sudo reboot
     ```

5. **Restore Desktop Packages:**
   - If the GUI still does not appear, reinstall the `ubuntu-desktop` package:
     ```bash
     sudo apt install --reinstall ubuntu-desktop
     ```

If you've ever encountered the same problem, following these steps can help you regain access to your graphical interface.

<p align="center">
  <img src="/images/minions-yay.gif" alt="Success Celebration">
</p>

## Corrective Measures

- **Use Supported Packages:** Always utilize package versions that are officially supported by your Ubuntu release to maintain stability.
- **Log File Review:** Regularly check log files (`/var/log/syslog`) to diagnose issues effectively.
- **System Maintenance:** Keep your system updated with the latest packages and security patches.

<p align="center">
  <img src="/images/ubuntu-logs.jpeg" alt="Ubuntu Logs">
</p>

## Preventative Measures

- **Verify Package Compatibility:** Before installing new packages, confirm their compatibility with your system to avoid conflicts.
- **Regular Backups:** Implement a backup strategy for important files and configurations to minimize data loss.
- **Create Restore Points:** Consider using system restore points or version control for easy recovery.
- **Stay Informed:** Keep up-to-date with the latest Ubuntu updates and potential issues.
- **Alternative Access Methods:** Maintain a secondary device or remote access option to reduce downtime during critical failures.

By following these guidelines, you can enhance system stability and reduce the likelihood of encountering similar boot issues in the future. Sharing this information can also assist others facing similar challenges.

