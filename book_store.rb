require 'ostruct'
require 'pry'
class BookStore
  attr_reader :books

  def initialize(books)
    @books = books
  end

  def self.calculate_price(books)
    bookstore = self.new(books)
    bookstore.calculate_price
  end

  def calculate_price
    total = 0
    if number_of_groups == 1
      total = book_group_price(books)
    elsif number_of_groups > 1
      if total_price(group_books(4)) < total_price(group_books(5))
        total = total_price(group_books(4))
        print group_books(4)
      else
        total = total_price(group_books(5))
        print "***"
        print group_books(5)
      end
    end
    total
  end

  private

  def total_price(groups)
    groups.map do |group|
      book_group_price(group)
    end.reduce(:+)
  end

  def group_books(max_group_size)
    book_counts_array = book_counts.to_a
    groups = [[]]
    group_index = 0
    until book_counts_array.empty?
      book_counts_array = book_counts_array.map do |book, count|
        if count > 0
          if groups[group_index].length == max_group_size
            group_index += 1
            groups[group_index] = []
            groups[group_index] << book
          elsif !groups[group_index].include?(book)
            groups[group_index] << book
          elsif groups[group_index].include?(book) && groups.count > 1
            unless groups.select {|f| !f.include?(book) }.first
              group_index += 1
            end
            groups = swap_book_with_other_group(book, groups)
          else
            group_index += 1
            groups[group_index] = []
            groups[group_index] << book
          end
        end
        if count > 0
          [book, (count -1)]
        end
      end.compact
    end
    groups
  end
  
  def swap_book_with_other_group(book, groups)
    last_group = groups.last
    other_groups = groups.select {|f| f.include?(book) }
    swap_groups = groups.select {|f| !f.include?(book) }
    swap_group = swap_groups.first
    if swap_group
      both_groups = last_group + swap_group + [book]
      arr_1 = []
      arr_2 = []
      both_groups.sort.each_slice(2) do |f|
        arr_1 << f[0]
        arr_2 << f[1]
      end
      other_groups[0..-2] << arr_1 << arr_2
    else
      groups << [book]
      groups
    end
  end

  def number_of_groups
    (books.length / 5.0).ceil
  end

  def book_counts
    book_counts = Hash.new(0)
    books.each { |book| book_counts[book] += 1 }
    book_counts
  end

  def book_group_price(group)
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
