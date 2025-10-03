# 🔀 Git Branching Strategy for RRule Refactoring

## Current Status
- **Main Branch:** `master` (stable, working version)
- **Working Directory:** Clean ✅

---

## Recommended Approach: Feature Branch

### Step 1: Create a Feature Branch for RRule Development

```powershell
# Create and switch to a new feature branch
git checkout -b feature/rrule-refactoring

# Push the branch to GitHub
git push -u origin feature/rrule-refactoring
```

### Step 2: Tag the Current Stable Version

```powershell
# Tag the current stable version before starting
git tag -a v1.0-pre-rrule -m "Stable version before RRule refactoring"
git push origin v1.0-pre-rrule
```

### Step 3: Work on Feature Branch

All RRule refactoring work happens on `feature/rrule-refactoring`:
- Commit regularly
- Push frequently to GitHub
- Can easily revert or restart

### Step 4: When RRule is Stable

```powershell
# Switch back to master
git checkout master

# Merge the feature branch
git merge feature/rrule-refactoring

# Push to GitHub
git push origin master
```

---

## Alternative Approach: Fork the Repository

If you want a completely separate copy on GitHub:

### Step 1: Fork on GitHub
1. Go to: https://github.com/JayMass5800/HabitV8
2. Click "Fork" button (top right)
3. Creates: `YourUsername/HabitV8` (separate repository)

### Step 2: Add Fork as Remote (Optional)
```powershell
# Add the fork as a remote
git remote add fork https://github.com/YourUsername/HabitV8.git

# Push to fork
git push fork master
```

---

## Branch Structure Recommendation

```
master (stable)
  │
  ├─── feature/rrule-refactoring (main development)
  │     │
  │     ├─── feature/rrule-service (Phase 2)
  │     ├─── feature/rrule-ui (Phase 4)
  │     └─── feature/rrule-migration (Phase 5)
  │
  └─── hotfix/critical-bugs (for urgent fixes to master)
```

---

## Safety Commands

### Revert to Stable Version
```powershell
# If things go wrong, go back to master
git checkout master

# Or go back to tagged version
git checkout v1.0-pre-rrule
```

### Discard All Changes on Feature Branch
```powershell
# Nuclear option: start over
git checkout feature/rrule-refactoring
git reset --hard origin/master
```

### Create a Backup Branch
```powershell
# Before risky changes, create a backup
git checkout -b backup/before-major-change
git checkout feature/rrule-refactoring
```

---

## Commit Strategy

### Good Commit Messages
```
✅ GOOD:
- "feat: Add RRuleService with basic conversion logic"
- "refactor: Update CalendarService to use RRuleService"
- "test: Add comprehensive tests for RRuleService.isDueOnDate"
- "fix: Handle null RRule strings in legacy migration"
- "docs: Update RRULE_REFACTORING_PLAN.md"

❌ BAD:
- "update"
- "changes"
- "fix stuff"
```

### Conventional Commits Format
```
<type>(<scope>): <description>

feat: New feature
fix: Bug fix
refactor: Code refactoring
test: Adding tests
docs: Documentation
chore: Maintenance tasks
```

---

## GitHub Protection Settings

Protect your master branch:

1. Go to: Repository → Settings → Branches
2. Add rule for `master`:
   - ✅ Require pull request reviews
   - ✅ Require status checks to pass
   - ✅ Prevent force pushes

---

## Workflow for Safe Development

```
Day 1: Create feature branch
├─ git checkout -b feature/rrule-refactoring
├─ Add RRule package to pubspec.yaml
├─ Commit: "chore: Add rrule package dependency"
└─ Push: git push -u origin feature/rrule-refactoring

Day 2-5: Implement RRuleService
├─ Create rrule_service.dart
├─ Commit: "feat: Implement RRuleService core methods"
├─ Write tests
├─ Commit: "test: Add RRuleService unit tests"
└─ Push regularly

Day 6-7: Update Habit model
├─ Add RRule fields
├─ Commit: "feat: Add RRule fields to Habit model"
├─ Regenerate Hive adapters
├─ Commit: "chore: Regenerate Hive type adapters"
└─ Push

... continue for each phase ...

Final: Merge to master
├─ All tests passing ✅
├─ Documentation complete ✅
├─ Beta tested ✅
└─ git checkout master && git merge feature/rrule-refactoring
```

---

## Emergency Rollback Plan

### If the app is broken on feature branch:
```powershell
# Option 1: Go back to master (working version)
git checkout master
flutter clean
flutter pub get
flutter run

# Option 2: Revert specific commits
git checkout feature/rrule-refactoring
git log --oneline  # Find the bad commit
git revert <commit-hash>

# Option 3: Reset to a good point
git reset --hard <good-commit-hash>
git push --force origin feature/rrule-refactoring
```

### If master gets broken (worst case):
```powershell
# Revert to tagged version
git reset --hard v1.0-pre-rrule
git push --force origin master  # Use with EXTREME caution
```

---

## Recommended: Create the Safe Setup Now

Run these commands to set up a safe development environment:

```powershell
# 1. Create a tag for current stable version
git tag -a v1.0-pre-rrule -m "Stable version before RRule refactoring - $(Get-Date -Format 'yyyy-MM-dd')"

# 2. Push the tag to GitHub
git push origin v1.0-pre-rrule

# 3. Create feature branch
git checkout -b feature/rrule-refactoring

# 4. Push feature branch to GitHub
git push -u origin feature/rrule-refactoring

# 5. Verify you're on the right branch
git branch --show-current
```

---

## Tracking Progress

Create GitHub issues for each phase:

```
Issue #1: [Phase 0] Setup RRule infrastructure
Issue #2: [Phase 1] Update Habit model
Issue #3: [Phase 2] Implement RRuleService
Issue #4: [Phase 3] Update service layer
Issue #5: [Phase 4] Update UI layer
Issue #6: [Phase 5] Data migration
Issue #7: [Phase 6] Legacy cleanup
Issue #8: [Phase 7] Testing & polish
```

Link commits to issues:
```powershell
git commit -m "feat: Implement RRuleService (#3)"
```

---

## Visual Branch Structure

```
Time ──────────────────────────────────────────────────►

master:        ●────────────────────────────────●
               │                                 ▲
               │ v1.0-pre-rrule                 │
               │                                 │ merge when stable
               │                                 │
feature/       └──●──●──●──●──●──●──●──●──●──●──┘
rrule:            │  │  │  │  │  │  │  │  │  │
                  │  │  │  │  │  │  │  │  │  │
                  └──┴──┴──┴──┴──┴──┴──┴──┴──┴─ regular commits
                  Phase 0 → Phase 7
```

---

## Summary: Your Safety Net

✅ **Tagged Version** (`v1.0-pre-rrule`): Can always go back  
✅ **Master Branch**: Untouched, always working  
✅ **Feature Branch**: Safe experimentation  
✅ **GitHub Backup**: All code pushed to remote  
✅ **Easy Rollback**: Multiple recovery options  

You can develop with confidence knowing you can always revert! 🛡️

---

**Next Steps:**
1. Review this strategy
2. Run the setup commands above
3. Start Phase 0 on the feature branch
4. Commit and push regularly
5. Merge to master only when fully stable

**Document Version:** 1.0  
**Created:** October 3, 2025  
**Status:** Ready to Execute
