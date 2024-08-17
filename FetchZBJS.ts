/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run "npm run dev" in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run "npm run deploy" to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */
// import { fromBinary } from './decode'

export default {
  async scheduled(event, env, ctx) {
    ctx.waitUntil(handleRequest(event.request, env));
  },
  async fetch(request, env, ctx) {
    // Get the value for the "to-do:123" key
    // NOTE: Relies on the `TODO` KV binding that maps to the "My Tasks" namespace.
    // handleRequest(event.request, env);
    let value = await env.zbjs.get("ww");
    return new Response(value);
  },
};

// export default {
//   async fetch(request, env, ctx) {
//     // Get the value for the "to-do:123" key
//     // NOTE: Relies on the `TODO` KV binding that maps to the "My Tasks" namespace.
//     return new Response('json', { status: 200 });

//     return handleRequest(event.request, env);
//   },
// };

// addEventListener('fetch', event => {
//   event.respondWith(handleRequest(event.request));
//   event.waitUntil(handleRequest(event.request));
// });

async function handleRequest(request, env) {
  const url = 'https://dy.zbjssub.xyz/api/v1/client/subscribe?token=4d311135d07d197d587f1416e7b1ef5d';
  const init = {
    headers: {
      "content-type": "application/json;charset=UTF-8",
    },
  };

  const response = await fetch(url, init);
  // console.log(response);

  // Example usage:
  // const encodedString = 'SGVsbG8gV29ybGQh';
  const encodedString = await response.text();
  const decodedString = base64Decode(encodedString);
  const ssArray = splitSSLinks(decodedString);
  const dictArray = tranformToArray(ssArray);
  const json = JSON.stringify(dictArray, null, 4);
  // let value = await zbjs.get("ww");
  await env.zbjs.put('ww', json);
  return new Response('json', { status: 200 });
  // return new Response(json, { status: 200 });
}

function tranformToArray(sourceArray) {
  const newArray = [];
  for (let i = 0; i < sourceArray.length; i++) {
    const value = sourceArray[i];
    const converted = parseSSRLink(value);
    newArray.push(converted);
  }
  return newArray;
}

function splitSSLinks(links) {
  // 利用换行符将字符串拆分成每一行
  const lines = links.split('\n');

  // 过滤掉空行，并且只保留以"ss://"开头的链接
  const ssLinks = lines.filter((line) => line.trim() !== '' && line.trim().startsWith('ss://'));

  // 返回拆分后的数组
  return ssLinks;
}

function parseSSRLink(ssrLink) {
  const parts = ssrLink.split(/[//#@:]+/);
  console.log(parts);

  if (parts.length < 5) {
    throw new Error('Invalid SSR link format');
  }

  const protocol = parts[0];
  if (!(protocol == 'ss' || protocol == 'ssr')) {
      throw new Error('is not ss');
  }

  const password = parts[1];
  const address = parts[2];
  const port = parts[3];
  const name = parts[4];
  var country_code = getCountryCode(address);
  
  let decodedPassword = base64Decode(password);
  decodedPassword = decodedPassword.replace("chacha20-ietf-poly1305:", "");
  decodedPassword = decodedPassword.replace("\u0000", "");

  const result = 
    {
      id: 0,
      name: formatNameFromDomain(address),
      country_code: country_code,
      type: "Shadowsocks",
      password: decodedPassword,
      encryptmethod: "chacha20-ietf-poly1305", // Assuming constant encryption method
      address: address,
      port: port,
      free: 0,
      city: "", // Assuming constant city name
      country: "", // Assuming constant country name
      remark: decodeURIComponent(name),
    };
  
  return result;
}

function getCountryCode(domain) {
  var country_code = 'us';

  if (domain.length > 2) {
    // 使用 split() 方法和正则表达式分割字符串
    var parts = domain.split(/\./);

    if (parts.length > 0) {
      var firstPart = parts[0];

      // 删除数字
      var withoutNumbers = firstPart.replace(/\d/g, '');
      // console.log(withoutNumbers); // 输出 "js"

      // 取最后两位字母
      country_code = withoutNumbers.slice(-2);
    }
    if (country_code == 't' || country_code == 'at') {
      country_code = 'tw';
    }
  }
  return country_code;
}

function formatNameFromDomain(domain) {
  const countryCodeMap = {
    'us': 'Unite States',
    'gb': 'United Kingdom',
    'sg': 'Singapore',
    'ge': 'Germany',
    'ca': 'Canada',
    'au': 'Australia',
    'nl': 'Netherlands',
    'hk': 'Hong Kong',
    'jp': 'Japan',
    'kr': 'Korea',
    'tw': 'Taiwan',
    'in': 'India',
    't': 'Taiwan',
  };

  const countryCode = getCountryCode(domain);
  const number = extractNumberFromFirstPart(domain);
  var code = countryCode + number;
  for (const key of Object.keys(countryCodeMap)) {
    if (code.includes(key)) {
      return code.replace(key, countryCodeMap[key]);
    }
  }

  return code;
}

function extractNumberFromFirstPart(inputString) {
  // 使用 split() 方法和正则表达式分割字符串
  var parts = inputString.split(/\./);

  if (parts.length >= 1) {
    var firstPart = parts[0];

    // 使用正则表达式匹配数字
    var match = firstPart.match(/\d+/);

    if (match && match[0]) {
      return match[0];
    } else {
      return "";
    }
  } else {
    return "";
  }
}

function base64Decode(encodedString) {
  const base64Url = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
  let decodedString = '';
  let ch1, ch2, ch3, enc1, enc2, enc3, enc4;
  let i = 0;

  // Remove any characters that are not base64
  encodedString = encodedString.replace(/[^A-Za-z0-9+/=]/g, '');

  while (i < encodedString.length) {
    enc1 = base64Url.indexOf(encodedString.charAt(i++));
    enc2 = base64Url.indexOf(encodedString.charAt(i++));
    enc3 = base64Url.indexOf(encodedString.charAt(i++));
    enc4 = base64Url.indexOf(encodedString.charAt(i++));

    ch1 = (enc1 << 2) | (enc2 >> 4);
    ch2 = ((enc2 & 15) << 4) | (enc3 >> 2);
    ch3 = ((enc3 & 3) << 6) | enc4;

    decodedString += String.fromCharCode(ch1);

    if (enc3 !== 64) {
      decodedString += String.fromCharCode(ch2);
    }
    if (enc4 !== 64) {
      decodedString += String.fromCharCode(ch3);
    }
  }

  return decodedString;
}

// export default {
//   async fetch(request, env, ctx) {
//     // Get the value for the "to-do:123" key
//     // NOTE: Relies on the `TODO` KV binding that maps to the "My Tasks" namespace.
//     let value = await env.zbjs.get("ww");

//     // Example usage:
//     // const encoded_string = 'dHJvamF';
//     // let decoded_string = base64_decode(encoded_string);
//     // decoded_string = querystring.unescape(decoded_string);
//     // decoded_string = base64_decode1(env);

//     // Return the value, as is, for the Response
//     return new Response(value);
//   },
// };



