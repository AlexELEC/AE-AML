BUILD_DIRS=build.*

all: release

system:
	./scripts/image_mt_ae

release:
	./scripts/image_mt_ae release

image:
	./scripts/image_mt_ae mkimage

system_mt:
	./scripts/image_mt

release_mt:
	./scripts/image_mt release

image_mt:
	./scripts/image_mt mkimage

addons_mt:
	./scripts/create_addon_mt all

clean:
	rm -rf $(BUILD_DIRS)/* $(BUILD_DIRS)/.stamps

distclean:
	rm -rf ./.ccache ./$(BUILD_DIRS)

src-pkg:
	tar cvJf sources.tar.xz sources .stamps
