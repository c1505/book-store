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
      else
        total = total_price(group_books(5))
      end
    end
    total
  end

  private
  
  def group_books(max_group_size)
    group = Group.new(book_counts, max_group_size)
    group.group_books
  end
  
  def total_price(groups)
    groups.map do |group|
      book_group_price(group)
    end.reduce(:+)
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

class Group
    attr_reader :book_counts, :groups, :group_index, :max_group_size
    
    def initialize(book_counts, max_group_size)
      @book_counts = book_counts.to_a
      @max_group_size = max_group_size
    end
    
    def group_books
      @groups = [[]]
      @group_index = 0
      until book_counts.empty?
        @book_counts = book_counts.map do |book, quantity|
          if quantity > 0
            add_book_to_group(book)
            [book, (quantity - 1)]
          end
        end.compact
      end
      groups
    end
    
    private
    
    def add_book_to_group(book)
      if book_included_in_current_group?(book) && @groups.count > 1
        unless any_groups_exist_excluding_current_book?(book)
          @group_index += 1
        end
        groups = swap_book_with_other_group(book)
      elsif book_excluded_in_current_group?(book) && below_max_group_size?
        @groups[group_index] << book
      elsif !below_max_group_size?
        increment_group
        @groups[group_index] << book
      else
        # goes in here when max group size is 5
        increment_group
        @groups[group_index] << book
      end
    end
    
    def increment_group
      @group_index += 1
      @groups[group_index] = []
    end
  
    def book_included_in_current_group?(book)
      @groups[group_index].include?(book)
    end
  
    def book_excluded_in_current_group?(book)
      !@groups[group_index].include?(book)
    end
    
    def any_groups_exist_excluding_current_book?(book)
      @groups.select {|f| !f.include?(book) }.first
    end
    
    def below_max_group_size?
      @groups[group_index].length < max_group_size
    end
  
    def swap_book_with_other_group(book)
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
        @groups = other_groups[0..-2] << arr_1 << arr_2
      else
        @groups << [book]
        @groups
      end
    end
  end

module BookKeeping
  VERSION = 0
end
