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

<!-- OpenGraph -->
<meta property="og:title" content="Anton Payments — Infrastructure Architecture">
<meta property="og:description" content="Multi-environment GKE architecture on Google Cloud Platform. Edge, compute, data, CI/CD, and observability layers.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://anton-payments.github.io/infra-page/">
<meta property="og:site_name" content="Anton Payments">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary">
<meta name="twitter:title" content="Anton Payments — Infrastructure Architecture">
<meta name="twitter:description" content="Multi-environment GKE architecture on Google Cloud Platform.">

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

# Each section is its own layout-row with aligned sidebar
for section in "${SECTIONS[@]}"; do
  NOTES="$DIR/src/sections/${section}-notes.html"

  echo "  <div class=\"layout-row section-row section-${section}\">" >> "$OUT"
  echo "    <div class=\"layout-main\">" >> "$OUT"

  cat "$DIR/src/sections/${section}.html" >> "$OUT"

  echo "    </div>" >> "$OUT"  # close .layout-main

  echo "    <div class=\"layout-sidebar\">" >> "$OUT"
  if [ -f "$NOTES" ]; then
    cat "$NOTES" >> "$OUT"
  fi
  echo "    </div>" >> "$OUT"  # close .layout-sidebar

  echo "  </div>" >> "$OUT"    # close .layout-row
done

# Legend (full width)
cat "$DIR/src/legend.html" >> "$OUT"

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
