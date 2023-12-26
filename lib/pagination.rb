module Pagination
  def self.paginate(query, current_page = 1, per_page = 10)
    paginated_query = query.page(current_page).per(per_page)
    {
      records: paginated_query,
      total_pages: paginated_query.total_pages,
      current_page: paginated_query.current_page,
      next_page: paginated_query.next_page,
      prev_page: paginated_query.prev_page,
      total_count: paginated_query.total_count
    }
  end
end
