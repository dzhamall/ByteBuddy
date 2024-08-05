BUMP_TYPE = ARGV[0]
CURRENT_TAG = ARGV[1]

unless /^(major|minor|patch)$/.match?(BUMP_TYPE)
	abort("Please, pass one of these major/minor/patch bump type.")
end

VERSION = CURRENT_TAG.match(/v([0-9]+\.[0-9]+\.[0-9]+)/).captures.first
VERSION_PARTS = VERSION.split(".").map(&:to_i)

if BUMP_TYPE == "major"
	VERSION_PARTS[0] += 1
	VERSION_PARTS[1] = 0
	VERSION_PARTS[2] = 0
elsif BUMP_TYPE == "minor"
	VERSION_PARTS[1] += 1
	VERSION_PARTS[2] = 0
elsif BUMP_TYPE == "patch"
	VERSION_PARTS[2] += 1
end
NEW_VERSION = VERSION_PARTS.join(".")
puts NEW_VERSION