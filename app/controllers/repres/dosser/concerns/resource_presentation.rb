##
# Resource Presentation 是 DOSSER 风格的资源表现逻辑的关注点。
# HTTP 状态码可参考以下链接：
# https://httpstatuses.com/
# http://www.restapitutorial.com/httpstatuscodes.html
# http://guides.rubyonrails.org/layouts_and_rendering.html#the-status-option

module Repres::Dosser::Concerns::ResourcePresentation

  extend ActiveSupport::Concern

  CODE_SUCCESS = 'success'.freeze
  CODE_FAILURE = 'failure'.freeze

  CODE_FAILURE_FORBIDDEN       = 'failure-forbidden'.freeze
  CODE_FAILURE_NOT_FOUND       = 'failure-not-found'.freeze
  CODE_FAILURE_WRONG_PARAMETER = 'failure-wrong-parameter'.freeze
  CODE_FAILURE_WRONG_STATE     = 'failure-wrong-state'.freeze

  included do |includer|

    attr_writer :criteria

    ##
    # 返回 HTTP 状态码 200 OK 。
    def render_ok(
      success:    true,
      code:       self.class::CODE_SUCCESS,
      message:    '成功',
      collection: [],
      size:       collection.size,
      errors:     {})
      respond_result :ok,
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
    end

    ##
    # 返回 HTTP 状态码 201 Created 。
    def render_created(
      success:    true,
      code:       self.class::CODE_SUCCESS,
      message:    '成功',
      collection: [],
      size:       collection.size,
      errors:     {})
      respond_result :created,
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
    end

    ##
    # 返回 HTTP 状态码 202 Accepted 。
    def render_accepted(
      success:    true,
      code:       self.class::CODE_SUCCESS,
      message:    '已接受',
      collection: [],
      size:       collection.size,
      errors:     {})
      respond_result :accepted,
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
    end

    ##
    # 返回 HTTP 状态码 204 No Content 。
    def render_no_content(
      success:    true,
      code:       self.class::CODE_SUCCESS,
      message:    '成功',
      collection: [],
      size:       collection.size,
      errors:     {})
      respond_result :no_content,
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
    end

    ##
    # 返回 HTTP 状态码 400 Bad Request 。
    def render_bad_request(
      success:    false,
      code:       self.class::CODE_FAILURE_WRONG_PARAMETER,
      message:    '参数错误',
      collection: [],
      size:       collection.size,
      errors:     {})
      respond_result :bad_request,
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
    end

    ##
    # 返回 HTTP 状态码 401 Unauthorized 。
    def render_unauthorized(
      success:    false,
      code:       self.class::CODE_FAILURE,
      message:    '请先登录',
      collection: [],
      size:       collection.size,
      errors:     {})
      respond_result :unauthorized,
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
    end

    ##
    # 返回 HTTP 状态码 403 Forbidden 。
    def render_forbidden(
      success:    false,
      code:       self.class::CODE_FAILURE_FORBIDDEN,
      message:    '无权访问',
      collection: [],
      size:       collection.size,
      errors:     {})
      respond_result :forbidden,
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
    end

    ##
    # 返回 HTTP 状态码 404 Not Found 。
    def render_not_found(
      success:    false,
      code:       self.class::CODE_FAILURE_NOT_FOUND,
      message:    '没有找到符合条件的信息',
      collection: [],
      size:       collection.size,
      errors:     {})
      respond_result :not_found,
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
    end

=begin
    # 404 not found - inexistent
    def render_inexistent(parameter_name, message)
      result = {
        success:    false,
        code:       self.class::CODE_FAILURE_NOT_FOUND,
        message:    message,
        collection: [],
        size:       0,
        errors:     { parameter_name => [ '不存在' ] }
      }
      respond_result :not_found, result
    end
=end

    ##
    # 返回 HTTP 状态码 409 Conflict 。
    def render_conflict(
      success:    false,
      code:       self.class::CODE_FAILURE_WRONG_STATE,
      message:    '',
      collection: [],
      size:       collection.size,
      errors:     {})
      respond_result :conflict,
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
    end

    ##
    # 返回 HTTP 状态码 500 Internal Server Error 。
    def render_internal_server_error(
      success:    false,
      code:       self.class::CODE_FAILURE,
      message:    '出现临时网络故障，请稍后重试。',
      collection: [],
      size:       collection.size,
      errors:     {})
      respond_result :internal_server_error,
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
    end

    ##
    # 根据参数，计算分页结果。如：
    # paginate total_items: 88, per_page: 10, current_page: 9
    # 返回
    # { total_items: 88, per_page: 10, current_page: 9, total_pages: 9, min_item_on_current_page: 80, max_item_on_current_page: 87, items_on_current_page: 8 }
    def paginate(total_items: 0, per_page: 0, current_page: 1)
      total_items  = total_items.to_i
      per_page     = per_page.to_i
      current_page = current_page.to_i

      raise ArgumentError.new('The total_items argument should be a positive integer.') if total_items<=0
      raise ArgumentError.new('The per_page argument should be a positive integer.')    if per_page<=0

      current_page = 1 if current_page<=0
      total_pages  = total_items/per_page+(total_items%per_page>0 ? 1 : 0)
      current_page = [ current_page, total_pages ].min
      min_item_on_current_page = per_page*(current_page-1)+1
      max_item_on_current_page = [ per_page*current_page, total_items ].min
      items_on_current_page    = max_item_on_current_page-min_item_on_current_page+1

      @pagination = { total_items: total_items, per_page: per_page, current_page: current_page, total_pages: total_pages, min_item_on_current_page: min_item_on_current_page, max_item_on_current_page: max_item_on_current_page, items_on_current_page: items_on_current_page }

    end

    ##
    # 按照给定的参数响应结果。此为内部方法。
    def respond_result(status, result)
      result[:meta] = { criteria: @criteria, request_id: request.uuid, timestamp: Time.now.to_i }
      result[:meta][:pagination] = @pagination if @pagination.present?
      respond_to do |format|
        format.json do render status: status, json: result end
        format.xml  do render status: status, xml:  result end
        format.js   do render status: status, js:   "/**/#{params[:callback]}(#{result.to_json});" end
      end
    end

    private :respond_result

  end

end
