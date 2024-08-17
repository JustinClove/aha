export default {
  async fetch(request, env) {
    return await handleRequest(request)
  }
}

async function handleRequest(request) {
var str = `
 {
    "free_days": 1,
    "allow_vip_short_uid": [],
    "disable_cache_node": false,
    "allow_region": null
  }`;

  return new Response(str);
}



export default {
  async fetch(request, env) {
    return await handleRequest(request)
  }
}

async function handleRequest(request) {
var str = `
 {
    "free_days": 5,
    "allow_vip_short_uid": ["7335BF6ENA_202305100155","8131D712CN_202304262142"],
    "disable_cache_node": false,
    "allow_region": ["CN"]
  }`;

  return new Response(str);
}
