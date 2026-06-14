FIREBASE_APP_ID_ANDROID := 1:804660931161:android:27e68838fa0ea335c79f48
FIREBASE_APP_ID_IOS     := 1:804660931161:ios:0ba6223b87036ee6c79f48

APK_PATH := build/app/outputs/flutter-apk/app-release.apk
IPA_PATH := $(shell find build/ios/ipa -name "*.ipa" 2>/dev/null | head -1)

VERSION := $(shell grep 'version:' pubspec.yaml | awk '{print $$2}')

.PHONY: help build-android distribute-android release-android \
        build-ios distribute-ios release-ios \
        release-all clean

help:
	@echo "Comandos disponibles:"
	@echo ""
	@echo "  Android:"
	@echo "    make build-android         Genera el APK de release"
	@echo "    make distribute-android    Sube el APK a Firebase App Distribution"
	@echo "    make release-android       Build + distribute (Android)"
	@echo ""
	@echo "  iOS:"
	@echo "    make build-ios             Genera el IPA de release"
	@echo "    make distribute-ios        Sube el IPA a Firebase App Distribution"
	@echo "    make release-ios           Build + distribute (iOS)"
	@echo ""
	@echo "  Ambos:"
	@echo "    make release-all           Build + distribute Android e iOS"
	@echo "    make clean                 Limpia los builds anteriores"

# ── Android ──────────────────────────────────────────────────────────────────

build-android:
	@echo ">> Generando APK release (v$(VERSION))..."
	flutter build apk --release
	@echo ">> APK listo: $(APK_PATH)"

distribute-android:
	@echo ">> Subiendo APK v$(VERSION) a Firebase App Distribution..."
	firebase appdistribution:distribute $(APK_PATH) \
		--app $(FIREBASE_APP_ID_ANDROID) \
		--groups "testers" \
		--release-notes "v$(VERSION)"
	@echo ">> Distribucion Android completada."

release-android: build-android distribute-android

# ── iOS ──────────────────────────────────────────────────────────────────────

build-ios:
	@echo ">> Generando IPA release (v$(VERSION))..."
	flutter build ipa --release
	@echo ">> IPA listo en: build/ios/ipa/"

distribute-ios:
	$(eval IPA_PATH := $(shell find build/ios/ipa -name "*.ipa" 2>/dev/null | head -1))
	@if [ -z "$(IPA_PATH)" ]; then echo "ERROR: No se encontro ningun IPA. Corre 'make build-ios' primero."; exit 1; fi
	@echo ">> Subiendo IPA v$(VERSION) a Firebase App Distribution..."
	firebase appdistribution:distribute $(IPA_PATH) \
		--app $(FIREBASE_APP_ID_IOS) \
		--groups "testers" \
		--release-notes "v$(VERSION)"
	@echo ">> Distribucion iOS completada."

release-ios: build-ios distribute-ios

# ── Ambos ─────────────────────────────────────────────────────────────────────

release-all: release-android release-ios

# ── Utils ─────────────────────────────────────────────────────────────────────

clean:
	flutter clean
