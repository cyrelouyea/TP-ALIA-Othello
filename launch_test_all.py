import sys
import subprocess
from typing import Tuple

class TestResult:

    def __init__(self, player: str, h1: int, h2: int, h3: int, depth: int):
        self.player = player
        self.h1 = h1
        self.h2 = h2
        self.h3 = h3
        self.depth = depth
        self.nb_games = 0
        self.nb_wins = 0
        self.nb_draws = 0
        self.total_time = 0.0

    def add_game(self, win: bool, draw: bool, time: float):
        if win:
            self.nb_wins += 1
        if draw:
            self.nb_draws += 1
        self.nb_games += 1
        self.total_time += time

    def __str__(self):
        return f"player={self.player} h1={self.h1} h2={self.h2} h3={self.h3} depth={self.depth} games={self.nb_games} wins={self.nb_wins} draws={self.nb_draws} win_rate={self.nb_wins/self.nb_games} draw_rate={self.nb_draws/self.nb_games} lose_rate={(self.nb_games-self.nb_wins-self.nb_draws)/self.nb_games} mean_time={self.total_time/self.nb_games}"

    def __repr__(self):
        return str(self)


class Parameters:

    PROGRAM = 'swipl'
    FILENAME = 'othello.prolog'
    GOALNAME = 'init'
    PLAYER = 'x'
    OPPONENT = 'o'

    def __init__(
        self,
        p_h1: int, p_h2: int, p_h3: int, p_depth: int,
        o_h1: int, o_h2: int, o_h3: int, o_depth: int
    ):
        self.p_h1 = p_h1
        self.p_h2 = p_h2
        self.p_h3 = p_h3
        self.p_depth = p_depth

        self.o_h1 = o_h1
        self.o_h2 = o_h2
        self.o_h3 = o_h3
        self.o_depth = o_depth

    def reverse(self):
        return Parameters(
            self.o_h1, self.o_h2, self.o_h3, self.o_depth,
            self.p_h1, self.p_h2, self.p_h3, self.p_depth
        )

    def execute(self, nb_times) -> Tuple[TestResult, TestResult]:
        result_player = TestResult('x', self.p_h1, self.p_h2, self.p_h3, self.p_depth)
        result_opponent = TestResult('o', self.o_h1, self.o_h2, self.o_h3, self.o_depth)

        for _ in range(nb_times):
            program = f"{self.PROGRAM} -g {self.GOALNAME} -t halt  {self.FILENAME} {self.PLAYER} {self.p_h1} {self.p_h2} {self.p_h3} {self.p_depth} {self.OPPONENT} {self.o_h1} {self.o_h2} {self.o_h3} {self.o_depth} false"
            p = subprocess.Popen(program, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
            (output, error) = p.communicate()
            p.wait()
            (winner, mean_time_player, mean_time_opponent) = self.process_output(output.decode())

            result_player.add_game(winner == self.PLAYER, winner == 'Draw', mean_time_player)
            result_opponent.add_game(winner == self.OPPONENT, winner == 'Draw', mean_time_opponent)
            
        return (result_player, result_opponent,)
        
    def process_output(self, output: str) -> Tuple[bool, int]:
        winner = ''
        total_time_player = 0.0
        total_time_opponent = 0.0
        total_play_player = 0
        total_play_opponent = 0
        for line in output.split('\n'):
            if line.startswith('Winner: '):
                winner = line[8:]
                break
            else:
                player, time = line.split()
                if player == self.PLAYER:
                    total_time_player += float(time)
                    total_play_player += 1
                elif player == self.OPPONENT:
                    total_time_opponent += float(time)
                    total_play_opponent += 1
        return (winner.strip(), total_time_player/total_play_player, total_time_opponent/total_play_opponent,)

    
import itertools
import threading

def test_heuristic(p: Parameters):
    for result in p.execute(nb_times):
        print(result)

with open(sys.argv[1], 'r') as f:
    nb_times = int(f.readline().strip())
    heuristics = []
    for line in f.readlines():
        nbs = line.strip().split()
        heuristics.append([float(nbs[0]), float(nbs[1]), float(nbs[2]), int(nbs[3])])
    # print(len([i for i in itertools.product(heuristics, heuristics)]))
    for player, opponent in itertools.product(heuristics, heuristics):
        p = Parameters(
            float(player[0]), float(player[1]), float(player[2]), int(player[3]), 
            float(opponent[0]), float(opponent[1]), float(opponent[2]), int(opponent[3]), 
        )
        test_heuristic(p)
        

