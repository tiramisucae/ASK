import discord
from discord.ext import commands, tasks
import asyncio
from datetime import datetime, time

# Intents 설정
intents = discord.Intents.default()
intents.messages = True
intents.guilds = True
intents.members = True

# 봇 생성
bot = commands.Bot(command_prefix='!', intents=intents)

# 피험자 ID 목록 (예시)
participants = [123456789012345678, 234567890123456789]  # 실제 디스코드 사용자 ID로 교체

async def send_survey_dm():
    """지정된 시간에 DM을 통해 설문조사 링크 전송"""
    for participant_id in participants:
        user = bot.get_user(participant_id)
        if user:
            try:
                await user.send('여기에서 설문조사에 참여하세요: https://example.com/survey')
                print(f"DM sent to {user.name}")
            except discord.Forbidden:
                print(f"Failed to send DM to {user.name}. Maybe they have DMs disabled.")
        await asyncio.sleep(1)  # 각 메시지 전송 사이에 잠시 대기

@tasks.loop(minutes=1)  # 매 분마다 실행하여 시간을 체크
async def check_time_and_send_dm():
    """설문조사 DM을 보낼 시간을 체크하여 DM을 보냄"""
    now = datetime.now().time()
    target_times = [time(10, 0), time(14, 0), time(20, 0)]  # 오전 10시, 오후 2시, 오후 8시

    for target_time in target_times:
        # 현재 시간이 목표 시간과 일치하는지 확인
        if now.hour == target_time.hour and now.minute == target_time.minute:
            await send_survey_dm()
            break  # 한번 실행 후 루프를 멈춤

@bot.event
async def on_ready():
    print(f'Logged in as {bot.user}')
    check_time_and_send_dm.start()  # 봇이 준비되면 시간 체크 작업 시작

@bot.event
async def on_message(message):
    if message.guild is None and message.author != bot.user:
        # DM에서 메시지를 받은 경우
        print(f"DM에서 받은 메시지: {message.content}")
        await message.channel.send('DM을 통해 응답해 주셔서 감사합니다!')
    # 명령어 처리도 허용
    await bot.process_commands(message)

@bot.event
async def on_command_error(ctx, error):
    if isinstance(error, commands.errors.CheckFailure):
        await ctx.send('이 명령어는 사용할 수 없습니다.')
    else:
        print(f'오류 발생: {error}')

# 토큰을 코드에 직접 넣지 말고 환경 변수나 외부 설정 파일을 통해 관리하는 것이 좋습니다.
bot.run('YOUR_BOT_TOKEN')
