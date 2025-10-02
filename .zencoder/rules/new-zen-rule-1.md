---
description: always use thiis rule, keep code modular
globs: []
alwaysApply: true
---


Rule: Maintain Modular File Structure

Always keep separate services, modules, and components in their own individual files. Never consolidate multiple services or systems into a single file. When editing or refactoring code:

Preserve the existing file structure and separation of concerns
If suggesting changes that span multiple files, maintain those boundaries
Only combine code within a single file if it belongs to the same service/module
If a file becomes too large (>500 lines), suggest splitting it into smaller modules rather than expanding it further