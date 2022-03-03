function ready()
{
	//плавный скролл
	const anchors = document.querySelectorAll('a[href*="#"]')

	for (let anchor of anchors)
	{
		anchor.addEventListener('click', function (e)
		{
			e.preventDefault()

			const blockID = anchor.getAttribute('href').substr(1)

			document.getElementById(blockID)?.scrollIntoView({
				behavior: 'smooth',
				block: 'start'
			})
		})
	}
	//меню выбора языка
	let langBtn = document.querySelectorAll('.header__change-lang')[0];

	langBtn?.addEventListener('click', () =>
	{
		langBtn.classList.toggle('_open');
	})

	//меню пользователя
	let userBtn = document.querySelectorAll('.header__user-btn')[0];

	userBtn?.addEventListener('click', () =>
	{
		userBtn.classList.toggle('_open');
	})

	//Сменить пароль
	let passBtn = document.querySelectorAll('.stat__change-pass')[0];

	passBtn?.addEventListener('click', () =>
	{
		passBtn.classList.toggle('_open');
	})

	//бургер-меню
	let button = document.querySelector('.burger-wrapper');

	button.addEventListener('click', () =>
	{
		button.classList.toggle("_open");
		document.body.classList.toggle("_lock");
	})

}
document.addEventListener("DOMContentLoaded", ready);