release-local:
	flutter build web --base-href=/build/web/ \
	--dart-define=MAPBOX_ACCESS_TOKEN=${MAPBOX_ACCESS_TOKEN} \
	--source-maps; \
	caddy run -config Caddyfile
