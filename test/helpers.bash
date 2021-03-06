setup() {
	export cacheInstallHost="mockhost"
	export cacheInstallPath="./"
	export build="$(pwd)/build"
	export testStart=$(pwd)
	export testTmp="$testStart/testTmp"
	export testPkg="$testTmp/pkg"
	export remote="$testTmp/remote"
	export PATH="$testStart/test/bin-mock:$PATH"
	export HOME=$testTmp
	export npmPrefix=$testTmp/npmPrefix
	mkdir -p $testPkg
	mkdir -p $remote
	cd $testPkg
	makePackageJson
	mkdir -p node_modules
	source $build/common
}
teardown() {
	cd $testStart
	rm -rf $testTmp
}
makePackageJson() {
	cat << json > package.json
{
	"dependencies": {
		"foo": "1.0.0",
		"bar": "1.0.0"
	},
	"devDependencies": {
		"dev-foo": "1.0.0",
		"dev-bar": "1.0.0"
	}
}
json
}
writeDotFile() {
	echo $HOME/.npm-cache-install
	cat > $HOME/.npm-cache-install << DOTFILE
export cacheInstallPath="dotfilecacheInstallPath"
export cacheInstallHost="dotfilecachehost"
DOTFILE
}
stubCacheInstallScripts() {
	export PATH="$testStart/test/cache-install-stubs:$PATH"
}
globalInstallPackage() {
	rm -rf $npmPrefix
	mkdir -p $npmPrefix
	pushd $testStart
	NPM_CONFIG_PREFIX=$npmPrefix npm install -g
	popd
	export PATH=$npmPrefix/bin:$PATH
}
