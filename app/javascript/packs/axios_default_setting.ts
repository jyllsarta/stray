import axios from 'axios'
const ax = axios.create({
  headers: {
    "X-AccessToken": localStorage.access_token,
    accept: "application/json",
  },
});
ax.interceptors.request.use((config) => {
  config.params = config.params || {};
  config.params['authenticity_token'] = document.querySelector("meta[name=csrf-token]").attributes["content"].textContent;;
  return config;
});
export default ax;
