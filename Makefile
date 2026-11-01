.PHONY: help test validate rebuild publish evidence pr bootstrap

help:
	@echo "make bootstrap - guided fork -> push -> PR -> evidence"
	@echo "make test      - run the calculator tests"
	@echo "make validate  - check every graded item"
	@echo "make rebuild   - rebuild the local Git history"
	@echo "make publish   - push to your GitHub fork"
	@echo "make pr        - print the pull request URL"
	@echo "make evidence  - regenerate the Git CLI evidence files"

bootstrap:
	@bash scripts/bootstrap.sh

test:
	@bash tests/test_simple_interest.sh

validate:
	@bash scripts/validate.sh

rebuild:
	@bash scripts/setup-local-repo.sh --force

publish:
	@bash scripts/publish.sh

pr:
	@bash scripts/open-pr.sh

evidence:
	@bash scripts/generate-evidence.sh
