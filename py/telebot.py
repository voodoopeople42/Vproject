import telebot;
bot = telebot.TeleBot('671322895:AAGI2APIeBHWI6SNU_qm1F1sECD0Ih_05VU');

@bot.message_handler(content_types=['text'])
def send_echo(message):
	bot.reply_to(message, message.text)

bot.polling(none_stop=True, interval=0)


if message.text == "Пиво":
    bot.send_message(message.from_user.id, "Заебал бухать")
elif message.text == "/help":
    bot.send_message(message.from_user.id, "Напиши привет")
else:
    bot.send_message(message.from_user.id, "Я тебя не понимаю. Напиши /help.")