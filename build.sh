#!/bin/bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
OUT="$DIR/index.html"

# Section pairs: main content + sidebar notes
SECTIONS=(edge gke data cicd monitoring)

cat > "$OUT" << 'HTMLHEAD'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Anton Payments — GKE Infrastructure Architecture</title>
<link href="https://api.fontshare.com/css?f[]=switzer@400,500,600,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="styles.css">
</head>
<body>

<div class="page">
HTMLHEAD

# Header
cat "$DIR/src/header.html" >> "$OUT"

# Environment switcher (full width, no sidebar)
cat "$DIR/src/env-switcher.html" >> "$OUT"

# Start the two-column layout
echo '' >> "$OUT"
echo '  <!-- ══ Two-column layout: main flow + sidebar notes ══ -->' >> "$OUT"
echo '  <div class="layout-row">' >> "$OUT"
echo '    <div class="layout-main">' >> "$OUT"
echo '      <div class="flow">' >> "$OUT"

# Main content column — all sections stacked
for section in "${SECTIONS[@]}"; do
  cat "$DIR/src/sections/${section}.html" >> "$OUT"
done

# Legend
cat "$DIR/src/legend.html" >> "$OUT"

echo '      </div>' >> "$OUT"  # close .flow
echo '    </div>' >> "$OUT"    # close .layout-main

# Sidebar column — all notes stacked
echo '    <div class="layout-sidebar">' >> "$OUT"

for section in "${SECTIONS[@]}"; do
  NOTES="$DIR/src/sections/${section}-notes.html"
  if [ -f "$NOTES" ]; then
    cat "$NOTES" >> "$OUT"
  fi
done

echo '    </div>' >> "$OUT"    # close .layout-sidebar
echo '  </div>' >> "$OUT"      # close .layout-row

# Footer
cat "$DIR/src/footer.html" >> "$OUT"

# Close page div
echo '</div>' >> "$OUT"

# Scripts
cat "$DIR/src/scripts.html" >> "$OUT"

# Close HTML
cat >> "$OUT" << 'HTMLFOOT'
</body>
</html>
HTMLFOOT

echo "Built: $OUT ($(wc -c < "$OUT" | tr -d ' ') bytes)"
