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
    binding.pry
    total = 0
    if number_of_groups == 1
      total = book_group_price(books)
    elsif number_of_groups > 1
      groups = group_by_maximum_discount
      total = total_price(groups)
    end
    total
  end

  private

  def total_price(groups)
    groups.map do |group|
      book_group_price(group)
    end.reduce(:+)
  end

  def group_by_maximum_discount
    group_1 = []
    group_2 = []
    group_3 = []
    group_4 = []
    switcher = false
    book_counts.each do |k, v|
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
    groups = [group_1, group_2, group_3, group_4]
  end

  def groups_of_four
    # remove one from book_counts and add to group
    # do the same for next key value pair
    # make a new group when the group size is 4
    book_counts_array = book_counts.to_a
    groups = [[]]
    group_index = 0
      book_counts_array.each_with_index do |book, count|
        if count > 0 && groups[group_index].length < 4
          groups[group_index] << book
        # elsif count == 0
        #   book_counts_temp.delete(book)
        else
          group_index += 1
          groups[group_index] = []
          groups[group_index] << book
        end
        [book, (count -1)]

      end
    binding.pry
  end

  def groups_of_five
    # remove one from book_counts and add to group
    # do the same for next key value pair
    # make a new group when the group size is 5
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
