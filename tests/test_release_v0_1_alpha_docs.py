from __future__ import annotations

import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]


class ReleaseV01AlphaDocsTest(unittest.TestCase):
    def test_readme_first_screen_states_alpha_boundaries(self) -> None:
        readme = (REPO_ROOT / "README.md").read_text(encoding="utf-8")
        first_screen = "\n".join(readme.splitlines()[:70])

        for term in ("v0.1-alpha", "stable", "experimental", "planned", "not implemented"):
            self.assertIn(term, first_screen)
        self.assertIn("AutoCAD/DXF plan validate / dry-run / guarded write", first_screen)
        self.assertIn("Photoshop, Illustrator, Blender, and CapCut write flows are experimental or planned", first_screen)

    def test_capability_matrix_has_required_columns(self) -> None:
        matrix = (REPO_ROOT / "docs" / "CAPABILITY_MATRIX.md").read_text(encoding="utf-8")
        required_header = (
            "| Bridge | MCP Tool | CLI Script | Reads | Writes | Dry-run | "
            "Needs Real Software | Current Status | Safety Notes |"
        )
        self.assertIn(required_header, matrix)
        for status in ("stable", "experimental", "planned", "not implemented"):
            self.assertIn(status, matrix)

    def test_release_doc_limits_v0_1_alpha_claims(self) -> None:
        release = (REPO_ROOT / "docs" / "RELEASE_V0_1_ALPHA.md").read_text(encoding="utf-8")

        self.assertIn("只承诺当前仓库里真实可运行", release)
        self.assertIn("structured unavailable", release)
        self.assertIn("confirm_write=true", release)
        self.assertIn("不是完整创意软件自动化平台", release)


if __name__ == "__main__":
    unittest.main()
