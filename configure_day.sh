#!/usr/bin/env bash

set -euo pipefail

if [ $# != 1 ]; then
  printf "Usage:\n\t%s <day>\n" "$0" 1>&2
  exit 1
fi

ruby_template=$(cat <<EOF
#!/usr/bin/env ruby

input = File.open("input.txt").each_line

def part1 (input)

end

def part2 (input)

end

puts "Part 1: #{part1(input)}"
puts "Part 2: #{part2(input)}"

EOF
)

day="$1"

source_dir="$(dirname "${BASH_SOURCE[0]}")"

cd "$source_dir"

if [ -e "$day" ]; then
  printf "Day %s already exists.\n" "$day" 1>&2
  exit 1
fi

mkdir "$day"
cd "$day"

echo "$ruby_template" > "day_${day}.rb"
chmod +x "day_${day}.rb"
touch "input_example.txt"
touch "input_real.txt"
ln -sf "input_example.txt" "input.txt"
touch "README.md"

cd ..
tree "$day"
