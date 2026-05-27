## Summary

- 

## Scope

- [ ] Documentation only
- [ ] Probe or validator
- [ ] MCP tool behavior
- [ ] Tests

## Safety Checklist

- [ ] No private paths, usernames, tokens, cookies, OAuth cache, license files, or account data.
- [ ] No PSD, AI, DWG, blend files, model checkpoints, LoRA, VAE, generated images, exported videos, or client assets.
- [ ] File-writing behavior is dry-run by default or requires explicit confirmation.
- [ ] Output paths are parameterized or use safe temporary directories.

## Validation

```powershell
python -m unittest discover -s tests
python scripts\security_check.py
python scripts\starbridge_preflight.py --markdown
```
