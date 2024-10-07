SoundFile swooshSound;
SoundFile selectSound;
SoundFile deselectSound;
SoundFile moveSound;
SoundFile foundSound;

void LoadSounds() {
  swooshSound = new SoundFile(this, "Swoosh.mp3");
  selectSound = new SoundFile(this, "Select.mp3");
  deselectSound = new SoundFile(this, "Deselect.mp3");
  moveSound = new SoundFile(this, "Move.mp3");
  foundSound = new SoundFile(this, "Found.mp3");
}
