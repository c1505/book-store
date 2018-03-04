class BookStore
  def self.calculate_price(books)
    counts = Hash.new(0)
    books.each { |book| counts[book] += 1 }
    number_of_groups = (books.length / 5.0).ceil
    total = 0

    if number_of_groups == 1
      total = self.book_group_price(books)
    elsif number_of_groups > 1
      group_1 = []
      group_2 = []
      group_3 = []
      group_4 = []
      switcher = false
      counts.each do |k, v|
        if v == 2
          if group_1.length > 3 && books.length > 12
            group_3 << k
            group_4 << k
          else
            group_1 << k
            group_2 << k
          end
        elsif v == 3
          group_1 << k
          group_2 << k
          group_3 << k
        elsif v == 4
          group_1 << k
          group_2 << k
          group_3 << k
          group_4 << k
        elsif switcher == false
          group_1 << k
          switcher = books.length != 6
        elsif switcher == true
          group_2 << k
        end
      end
      puts group_1
      puts  "***********"
      puts group_2
      puts  "***********"
      puts group_3
      puts  "***********"
      puts group_4
      total = self.book_group_price(group_1) + self.book_group_price(group_2) +
        self.book_group_price(group_3) + self.book_group_price(group_4)
    end

    total

  end

  private

  def self.book_group_price(group)
    case group.uniq.length
    when 0..1
      group.length * 8
    when 2
      group.length * 8 * 0.95
    when 3
      group.length * 8 * 0.90
    when 4
      group.length * 8 * 0.80
    when 5
      group.length * 8 * 0.75
    end
  end
end

module BookKeeping
  VERSION = 0
end
