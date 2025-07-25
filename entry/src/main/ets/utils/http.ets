import axios, { InternalAxiosRequestConfig, AxiosResponse, AxiosError, AxiosInstance } from '@ohos/axios';
import promptAction from '@ohos.promptAction';
import { checkStatus } from './checkStatus';
import { logger } from './Logger';
import apiConfig from '../../resources/base/profile/api_config.json';
interface pageData {
  pages?:string;
  current?:string;
  size?: string;
  total?:string;
  records?:Array<object>;
}
interface ApiResponse<pageData> { //根据项目实际项目修改
  code?: number;
  data: pageData | null;
  msg?: string;
}

// 创建实例
const instance: AxiosInstance = axios.create({
  // 默认地址请求地址
  baseURL: apiConfig['dev'].baseUrl, //修改为自己项目的实际地址
  // 设置超时时间
  timeout: 100000,
  headers: {
    'Content-Type': 'application/json;charset=utf-8',
    'Content-Language': 'zh_CN',
    'deviceId':''
  },
});

// 添加请求拦截器
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 对请求数据做点什么
  const token = '6852b09bdb186ed36e71a82dd0e4bd1d'
  if (token) {
    config.headers['token'] = token //设置token
    config.headers['meta-tenant-id'] = "1676491049528705026"
  }
  return config
}, (error: AxiosError) => {
  // 对请求错误做些什么
  logger.error("Error1", JSON.stringify(error))
  return Promise.reject(error)
})

// 添加响应拦截器 错误统一处理等
instance.interceptors.response.use((response: AxiosResponse) => {
  // 对响应数据做点什么
  // 下面配置根据系统返回来配置的，不同的系统配置不同
  if (response.data.code == 0) { // 这里是举例 要根据自己项目的实际情况进行处理
    // promptAction.showToast({
    //   //用到了 @kit.ArkUI 的 promptAction进行系统弹窗提示
    //   message: response.data.massage,
    //   duration: 2000,
    //   alignment: Alignment.Center
    // });
    logger.info("请求成功", JSON.stringify(response))
    return Promise.resolve(response.data);
  } else {
    logger.error("Error2", JSON.stringify(response))

    // 根据不同的错误码进行不同的处理
    // promptAction.showToast({
    //   message: response.data.msg,
    //   duration: 2000
    // })
    return Promise.resolve(response.data);
  }
}, (error: AxiosError) => {
  // 请求超时 && 网络错误单独判断，没有 response
  if (error.message.indexOf("timeout") !== -1) {
    promptAction.showToast({ message: "请求超时！请您稍后重试" });
  }
  if (error.message.indexOf("Network Error") !== -1) {
    promptAction.showToast({ message: "网络错误！请您稍后重试" });
  }
  console.log("AxiosError", JSON.stringify(error.response))
  // 根据服务器响应的错误状态码，做不同的处理
  const status = error.response?.status;
  console.log('status', status)
  if (status) {
    checkStatus(status);
  }
  logger.error("error", JSON.stringify(error))
  return Promise.reject(error)
})


// 封装请求方法
class HttpRequest {
  get<T>(url: string, params?: object): Promise<ApiResponse<T>> {
    return instance.get<null, ApiResponse<T>>(url, { params })
  }

  // 封装post方法
  post<T>(url: string, data?: object): Promise<ApiResponse<T>> {
    return instance.post<null, ApiResponse<T>>(url, data)
  }

  // 封装delete方法
  delete<T>(url: string, data?: object): Promise<ApiResponse<T>> {
    return instance.delete<null, ApiResponse<T>>(url, data)
  }

  // 封装put方法
  put<T>(url: string, data?: object): Promise<ApiResponse<T>> {
    return instance.put<null, ApiResponse<T>>(url, data)
  }
}

export const http = new HttpRequest();