import telebot

bot = telebot.TeleBot("671322895:AAGI2APIeBHWI6SNU_qm1F1sECD0Ih_05VU")

@bot.message_handler(content_types = ['text'])
def get_text_messages(message):
	bot.reply_to(message, "Howdy, how are you doing?")

