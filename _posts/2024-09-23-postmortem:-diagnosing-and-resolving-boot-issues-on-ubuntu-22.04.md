---
layout: post
title: "Postmortem: Diagnosing and Resolving Boot Issues on Ubuntu 22.04"
date: 2024-09-23
tags: [postmortem, ubuntu, black screen]
---

## Postmortem: Diagnosing and Resolving Boot Issues on Ubuntu 22.04

<p align="center">
  <img src="/images/tech-fails.gif" alt="Tech Failures">
</p>

## Issue Summary

On June 9, 2023, between 11:05 AM and 1:40 PM EAT, my Ubuntu 22.04 laptop encountered a critical boot issue, starting up to a terminal without a graphical user interface (GUI). This disruption severely affected my workflow, limiting all tasks to the command line.

## Timeline

**Note: All times are in EAT**

### 11:05 AM - 11:20 AM

<p align="center">
  <img src="/images/sys_restart.jpg" alt="System Restart">
</p>

- **Description:** Attempted multiple restarts to regain access to the laptop.
- **Outcome:** Each attempt resulted in a terminal display.

### 11:20 AM - 11:30 AM

- **Description:** Executed a system update and package upgrade.
- **Outcome:** Update and upgrade completed successfully.

### 11:30 AM - 11:40 AM

- **Description:** Checked log files (`/var/log/syslog`) for root cause analysis.
- **Outcome:** Identified a problem with the Light Display Manager; none was available.

### 11:40 AM - 12:00 PM

- **Description:** Installed the LightDM display manager as a potential fix.
- **Outcome:** The issue persisted.

### 12:00 PM - 1:20 PM

- **Description:** Reviewed log files to check the default display manager.
- **Outcome:** Confirmed GDM (GNOME Display Manager) as the default.

### 1:20 PM - 1:30 PM

- **Description:** Reinstalled a broken GDM3 (GNOME Display Manager).
- **Outcome:** Reinitialized the system and regained GUI access.

### 1:30 PM - 1:40 PM

- **Description:** Reinstalled the `ubuntu-desktop` package to restore the desktop environment.
- **Outcome:** GUI successfully displayed.

## Root Cause

The boot issue was primarily due to the absence of a compatible display manager, which stemmed from a forced installation of an incompatible package. This caused dependency conflicts and package version mismatches, leading to the disruption of display-related functionalities.

## Resolution and Recovery

To resolve the issue and restore the graphical interface, the following steps were taken:

- Rolled back installations of `libglapi-mesa` and `libegl1-mesa0` to compatible versions.
- Performed a system update and package upgrade.
- Attempted installation of `LightDM`, which proved incompatible.
- Reinstalled `GDM3`, the default display manager for GNOME environments.
- Reinitialized the system to apply the changes.
- Reinstalled the `ubuntu-desktop` package to retrieve essential desktop packages.

After these actions, the laptop was restored to normal functionality with a working GUI.

<p align="center">
  <img src="/images/minions-yay.gif" alt="Success Celebration">
</p>

## Corrective and Preventative Measures

### Corrective Measures

- Utilize package versions officially supported by the Ubuntu OS release to maintain system stability.
- Review log files (`/var/log/syslog`) to diagnose issues and determine appropriate responses.
- Regularly update and upgrade the system to ensure the latest packages and security patches are applied.

<p align="center">
  <img src="/images/ubuntu-logs.jpeg" alt="Ubuntu Logs">
  <img src="/images/log-files.jpg" alt="Log Files">
</p>

### Preventative Measures

- Verify package compatibility before installation to avoid conflicts.
- Regularly back up important files and configurations to minimize data loss.
- Consider creating system restore points or using version control for easy recovery.
- Stay informed about the latest updates and potential issues related to the operating system.
- Maintain a secondary system or alternative access method to reduce downtime during critical issues.

By adhering to these measures, system stability and compatibility can be ensured, significantly reducing the likelihood of similar boot issues in the future.
