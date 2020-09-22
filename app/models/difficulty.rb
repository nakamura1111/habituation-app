class Difficulty < ActiveHash::Base
  self.data = [
    { grade: 0, name: '楽勝' },
    { grade: 1, name: 'まあ楽勝' },
    { grade: 2, name: 'まあまあ' },
    { grade: 3, name: 'しんどい' },
    { grade: 4, name: 'ちょーしんどい' }
  ]
end
