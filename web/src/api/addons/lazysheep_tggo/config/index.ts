import { http } from '@/utils/http/axios';

export function getConfig(params) {
  return http.request({
    url: '/lazysheep_tggo/config/get',
    method: 'get',
    params,
  });
}

export function updateConfig(params) {
  return http.request({
    url: '/lazysheep_tggo/config/update',
    method: 'post',
    params,
  });
}

export function inspectBot(params) {
  return http.request({
    url: '/lazysheep_tggo/config/inspectBot',
    method: 'post',
    params,
  });
}

export function deleteBot(params) {
  return http.request({
    url: '/lazysheep_tggo/config/deleteBot',
    method: 'post',
    params,
  });
}

export function startBot(params) {
  return http.request({
    url: '/lazysheep_tggo/config/startBot',
    method: 'post',
    params,
  });
}

export function botUsers(params) {
  return http.request({
    url: '/lazysheep_tggo/config/botUsers',
    method: 'get',
    params,
  });
}

export function updateBotUser(params) {
  return http.request({
    url: '/lazysheep_tggo/config/updateBotUser',
    method: 'post',
    params,
  });
}

export function testTelegramProxy(params) {
  return http.request({
    url: '/lazysheep_tggo/config/testTelegramProxy',
    method: 'post',
    params,
  });
}
