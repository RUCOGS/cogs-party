using Godot;
using Godot.Collections;

/// <summary>
/// MiniGameManagerC is a C# wrapper for mini_game_manager.gd, providing C# functionality to the manager script for users of C# in Godot. The original manager script should be assigned in node inspector.
/// <para>There are various signals you can connect to to detect when the game starts and ends.</para>
/// <para>Players should be given points using <c>setPlayerResultPoints()</c> or <c>addPlayerResultPoints()</c></para>
/// </summary>
public partial class MiniGameManagerC : Node
{
	[Export] public GDScript mini_game_manager; //Original manager script, should be set in inspector
	[Export] public string game_name = "Test Game";
	[Export] public int min_player_count = 2;
	[Export] public int max_player_count = 4;
	[Signal] public delegate void GameStartedEventHandler(GodotObject[] PlayerData); //Emitted on game start
	[Signal] public delegate void GameEndedEventHandler(); //Emitted on game end
	private Node ManagerNode;
	private GodotObject[] PlayerData;
	private Array<Dictionary> ResultsArray;
	private Array<Color> PlayerColors = new Array<Color>();
	public override void _Ready()
	{
		if (mini_game_manager == null){
			GD.PrintErr("mini_game_manager.gd script was not found! Assign the script in node inspector.");
		}
		//Initialize GDManager
		ManagerNode = new Node();
		ManagerNode.SetScript(mini_game_manager);
		this.AddChild(ManagerNode);

		//Set the exported properties of GDManager
		ManagerNode.Set("game_name", game_name);
		ManagerNode.Set("min_player_count", min_player_count);
		ManagerNode.Set("max_player_count", max_player_count);

		//Connect game_started signal to wrapper handler
		ManagerNode.Connect("game_started", new Callable(this, MethodName.OnGameStarted));
	}

	/// <summary>
	/// Gets the array of colors which correspond to each player
	/// <para>Ex. <c>getPlayerColors()[0]</c> returns the color of player 1</para>
	/// </summary>
	public Array<Color> GetPlayerColors(){
		return PlayerColors;
	}

	/// <summary>
	/// Gets the already saved points of a player
	/// <para>This returns points from save, it does not show points earned in this game.</para>
	/// </summary>
	/// <param name="index">index of the player</param>
	public int GetPlayerPoints(int index){
		return PlayerData[index].Get("points").AsInt32();
	}

	/// <summary>
	/// Gets the number of points that a player has earned during the game
	/// </summary>
	/// <param name="index">index of the player</param>
	public int GetPlayerResultPoints(int index){
		return ResultsArray[index]["points"].AsInt32();
	}
	/// <summary>
	/// Sets the result points a player has earned
	/// </summary>
	/// <param name="index">index of the player</param>
	/// <param name="points">number to set for player's earned points</param>
	public void SetPlayerResultPoints(int index, int points){
		ResultsArray[index]["points"] = points;
	}
	/// <summary>
	/// Directly add result points for a player
	/// </summary>
	/// <param name="index">index of the player</param>
	/// <param name="points">amount of points to add</param>
	public void AddPlayerResultPoints(int index, int points){
		ResultsArray[index]["points"] = GetPlayerResultPoints(index) + points;
	}

	/// <summary>
	/// Ends the game and applies earned points
	/// <para>Result points should be updated using <c>setPlayerResultPoints()</c> or <c>addPlayerResultPoints()</c></para>
	/// </summary>
	public void EndGame(){
		this.EmitSignal(SignalName.GameEnded);
		ManagerNode.Call("apply_results", ResultsArray);
		ManagerNode.Call("end_game");
	}

	/// <summary>
	/// Wrapper for Event game_started
	/// </summary>
	/// <param name="pData">Array of PlayerData</param>
	public void OnGameStarted(GodotObject[] pData){
		PlayerData = pData;
		ResultsArray = new Array<Dictionary>();
		for (int i = 0; i < PlayerData.Length; i++){
			PlayerColors.Add(PlayerData[i].Get("color").AsColor());		//Initialize player colors from manager
			ResultsArray.Add(new Dictionary{{"player", i}, {"points", 0}});  //initialize results array
		}
		this.EmitSignal(SignalName.GameStarted, pData);
	}
}
