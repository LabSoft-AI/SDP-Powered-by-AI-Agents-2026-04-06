This is a course repository for "Software Development Processes Powered by AI Agents".
It contains course materials (markdown, PlantUML diagrams, starter agent configs),
not production application code.

When reviewing PRs:
- Focus on correctness of instructions and examples students will follow
- Verify commands are copy-pasteable and work as documented
- Check that file paths in examples match the actual repo structure
- Ensure consistency between theory sections and exercise steps
- Flag any references to tools/commands that aren't installed by setup.sh
- Slides (.md files in slides/ dirs) are presentation content — don't flag
  them for covering concepts beyond what the repo itself implements
- The commit convention is: #<issue> <type>(<scope>): <description>
- Pre-commit hooks enforce: filesystem checks, detect-secrets, PlantUML
  SVG generation, and commit message format
