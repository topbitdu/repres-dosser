module Repres::Dosser::Concerns::ResourcePresentation

  extend ActiveSupport::Concern

  CODE_SUCCESS = 'success'.freeze
  CODE_FAILURE = 'failure'.freeze

  CODE_FAILURE_NOT_FOUND       = 'failure-not-found'.freeze
  CODE_FAILURE_WRONG_PARAMETER = 'failure-wrong-parameter'.freeze
  CODE_FAILURE_WRONG_STATE     = 'failure-wrong-state'.freeze

  self.included do |includer|

    attr_writer :criteria

    # 200
    def render_ok(collection: [], success: true, code: self.class::CODE_SUCCESS, message: '成功', size: collection.size, errors: {})
      result = {
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
      }
      respond_result :ok, result
    end

    # 201
    def render_created(collection: [], success: true, code: self.class::CODE_SUCCESS, message: '成功', size: collection.size, errors: {})
      result = {
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
      }
      respond_result :created, result
    end

    # 400
    def render_bad_request(success: false, code: self.class::CODE_FAILURE_WRONG_PARAMETER, message: '参数错误', collection: [], size: 0, errors: {})
      result = {
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
      }
      respond_result :bad_request, result
    end
=begin
    # 400 bad request - blank parameter
    def render_blank_parameter(success: false, code: self.class::CODE_FAILURE_WRONG_PARAMETER, message: '参数', parameter_name)
      result = {
        success:    false,
        code:       self.class::CODE_FAILURE_WRONG_PARAMETER,
        message:    "#{parameter_name}参数不能为空。",
        collection: [],
        size:       0,
        errors:     { parameter_name => [ '不能为空' ] }
      }
      respond_result :bad_request, result
    end
=end
    # 404
    def render_not_found(success: false, code: self.class::CODE_FAILURE_NOT_FOUND, message: '没有找到符合条件的信息', collection: [], size: 0, errors: {})
      result = {
        success:    success,
        code:       code,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
      }
      respond_result :not_found, result
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
    def render_conflict(success: false, code: self.class::CODE_FAILURE_WRONG_STATE, message: '', collection: [], size: 0, errors: {})
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

    def render_internal_server_error(success: false, code: self.class::CODE_FAILURE, message: '出现临时网络故障，请稍后重试。', collection: [], size: 0, errors: {})
      respond_result :conflict, success: success, code: code, message: message, collection: collection, size: size, errors: errors
    end

    def respond_result(status, result)
      result[:meta] = { request_id: request.uuid, criteria: @criteria }
      respond_to do |format|
        format.json do render status: status, json: result end
        format.xml  do render status: status, xml:  result end
      end
    end

    private :respond_result

  end

end
