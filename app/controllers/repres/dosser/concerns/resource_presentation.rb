module Repres::Dosser::Concerns::ResourcePresentation

  extend ActiveSupport::Concern

  CODE_SUCCESS = 'success'.freeze
  CODE_FAILURE = 'failure'.freeze

  CODE_FAILURE_FORBIDDEN       = 'failure-forbidden'.freeze
  CODE_FAILURE_NOT_FOUND       = 'failure-not-found'.freeze
  CODE_FAILURE_WRONG_PARAMETER = 'failure-wrong-parameter'.freeze
  CODE_FAILURE_WRONG_STATE     = 'failure-wrong-state'.freeze

  self.included do |includer|

    attr_writer :criteria

    # https://httpstatuses.com/
    # http://www.restapitutorial.com/httpstatuscodes.html
    # http://guides.rubyonrails.org/layouts_and_rendering.html#the-status-option

    # 200
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

    # 201
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

    # 204
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

    # 400
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

    # 401
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

    # 403 forbidden
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

    # 404
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

    # 409
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

=begin
    # 409 conflict - wrong parameter
    def render_wrong_parameter(success: false, code: self.class::CODE_FAILURE_WRONG_PARAMETER, message: '', collection: [], size: 0, errors: {})
      result = {
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
      }
      respond_result :conflict, result
    end
=end

    # 500
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

    def respond_result(status, result)
      result[:meta] = { criteria: @criteria, request_id: request.uuid, timestamp: Time.now.to_i }
      respond_to do |format|
        format.json do render status: status, json: result end
        format.xml  do render status: status, xml:  result end
      end
    end

    private :respond_result

  end

end
