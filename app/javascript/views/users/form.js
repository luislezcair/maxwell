function setBlankPassword() {
  const input = document.getElementById('user_password');
  if (input) {
    setTimeout(() => { input.value = ''; }, 100);
  }
}

document.addEventListener('users:edit:load', setBlankPassword);
