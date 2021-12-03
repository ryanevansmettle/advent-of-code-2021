#!/usr/bin/env bash

set -euo pipefail

if [ $# != 1 ]; then
  printf "Usage:\n\t%s <day>\n" "$0" 1>&2
  exit 1
fi

day="$1"

ruby_template=$(cat <<EOF
#!/usr/bin/env ruby

require_relative '../lib/util'

class Day${day} < Scenario

  # @param [File] input
  def grok_input(input)
    Input.to_lines(input)
  end

  def part1 (input)

  end

  def part1_expected_result
    nil
  end

  def part2 (input)

  end

  def part2_expected_result
    nil
  end

end

Day${day}.new

EOF
)

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
