#!/usr/bin/env bash
#
# deploy.sh — pubblica il sito statico "Teatro del Pero" su Netlify.
#
# Uso:
#   ./scripts/deploy.sh            # deploy di PRODUZIONE
#   ./scripts/deploy.sh --preview  # deploy di ANTEPRIMA (URL temporaneo)
#
# Credenziali: lette da scripts/.deploy.env (non versionato) oppure da
# variabili d'ambiente NETLIFY_SITE_ID e NETLIFY_AUTH_TOKEN.
# Vedi DEPLOY.md per i dettagli.

set -euo pipefail

# --- posizioni ---------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PUBLISH_DIR="$PROJECT_ROOT/site"
ENV_FILE="$SCRIPT_DIR/.deploy.env"

# --- modalità ----------------------------------------------------------------
PROD=1
for arg in "$@"; do
  case "$arg" in
    --preview) PROD=0 ;;
    --prod|--production) PROD=1 ;;
    -h|--help)
      grep '^#' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "Argomento non riconosciuto: $arg" >&2
      echo "Usa: $0 [--preview|--prod]" >&2
      exit 2
      ;;
  esac
done

# --- carica credenziali ------------------------------------------------------
if [[ -f "$ENV_FILE" ]]; then
  echo "→ Carico le credenziali da $ENV_FILE"
  # shellcheck disable=SC1090
  set -a; source "$ENV_FILE"; set +a
fi

MISSING=0
if [[ -z "${NETLIFY_AUTH_TOKEN:-}" ]]; then
  echo "✗ Manca NETLIFY_AUTH_TOKEN." >&2
  MISSING=1
fi
if [[ -z "${NETLIFY_SITE_ID:-}" ]]; then
  echo "✗ Manca NETLIFY_SITE_ID." >&2
  MISSING=1
fi
if [[ "$MISSING" -eq 1 ]]; then
  cat >&2 <<'EOF'

Imposta le credenziali in scripts/.deploy.env:

  NETLIFY_SITE_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  NETLIFY_AUTH_TOKEN="il-tuo-token"

Site ID:  dashboard → Site configuration → General → Site information → Site ID
Token:    https://app.netlify.com/user/applications#personal-access-tokens
EOF
  exit 1
fi

# --- controlli sulla cartella da pubblicare ----------------------------------
if [[ ! -d "$PUBLISH_DIR" ]]; then
  echo "✗ Cartella da pubblicare non trovata: $PUBLISH_DIR" >&2
  exit 1
fi
if [[ ! -f "$PUBLISH_DIR/index.html" ]]; then
  echo "✗ $PUBLISH_DIR non contiene index.html: controlla il percorso." >&2
  exit 1
fi

# --- deploy ------------------------------------------------------------------
echo "→ Cartella pubblicata: $PUBLISH_DIR"
if [[ "$PROD" -eq 1 ]]; then
  echo "→ Modalità: PRODUZIONE"
  PROD_FLAG="--prod"
else
  echo "→ Modalità: ANTEPRIMA (URL temporaneo)"
  PROD_FLAG=""
fi

export NETLIFY_AUTH_TOKEN
# shellcheck disable=SC2086
npx --yes netlify-cli deploy \
  --dir="$PUBLISH_DIR" \
  --site="$NETLIFY_SITE_ID" \
  --message="Deploy da deploy.sh del $(date '+%Y-%m-%d %H:%M')" \
  $PROD_FLAG

echo "✓ Deploy completato."
