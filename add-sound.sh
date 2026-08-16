#!/usr/bin/env bash
set -euo pipefail

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="$THEME_DIR/stereo"

SONGS="dialog-error dialog-warning dialog-information dialog-question 
message-new-instant message-new-email 
device-added device-removed 
service-login service-logout 
complete bell trash-empty"

usage() {
    echo "Uso: $0 <nome-canonico> <arquivo-de-audio>"
    echo
    echo "Nomes canonicos (freedesktop/GTK):"
    printf '  %s\n' $SONGS
    echo
    echo "Exemplo:"
    echo "  $0 dialog-error meu-som.mp3"
    exit 1
}

[ $# -eq 2 ] || usage

NAME="$1"
SRC="$2"

case " $SONGS " in
    *" $NAME "*) ;;
    *) echo "Aviso: '$NAME' nao e um nome canonico conhecido" >&2 ;;
esac

[ -f "$SRC" ] || { echo "Erro: arquivo '$SRC' nao encontrado" >&2; exit 1; }

DEST="$OUT_DIR/$NAME.wav"
if [ -f "$DEST" ]; then
    echo "Aviso: '$DEST' ja existe, substituindo" >&2
fi

ffmpeg -hide_banner -loglevel error -y -i "$SRC" -ac 2 -ar 44100 "$DEST"
echo "OK -> $DEST"