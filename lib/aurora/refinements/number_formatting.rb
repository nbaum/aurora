module Aurora

  module Refinements

    module NumberFormatting

      refine Numeric do

        def binary_si (suffix = "B")
          prefixes = [
            [1024**8, " Yi"],
            [1024**7, " Zi"],
            [1024**6, " Ei"],
            [1024**5, " Pi"],
            [1024**4, " Ti"],
            [1024**3, " Gi"],
            [1024**2, " Mi"],
            [1024**1, " Ki"],
            [1024**0, " "],
          ]
          prefixes.each do |mul, prefix|
            next if self / mul == 0
            return ("%.2f" % [self / mul.to_f]).gsub(/\.0+$/, '') + prefix + suffix
          end
          return "0" + suffix
        end

        def decimal_si (suffix = "B")
          prefixes = [
            [1000**8, " Y"],
            [1000**7, " Z"],
            [1000**6, " E"],
            [1000**5, " P"],
            [1000**4, " T"],
            [1000**3, " G"],
            [1000**2, " M"],
            [1000**1, " k"],
            [1000**0, " "],
          ]
          prefixes.each do |mul, prefix|
            next if self / mul == 0
            return ("%.2f" % [self / mul.to_f]).gsub(/\.0+$/, '') + prefix + suffix
          end
          return "0" + suffix
        end

        def delimited
          to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
        end

      end

    end

  end

end
