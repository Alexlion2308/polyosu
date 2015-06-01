<?php include('login.php'); ?>
<?php

	setlocale(LC_ALL, array('fr_FR.UTF-8','fr_FR@euro','fr_FR','french'));
	date_default_timezone_set('Europe/Paris');

	$id = $_POST['id'];
	$nom = $_POST['nom'];
	$prenom = $_POST['prenom'];
	$email = $_POST['email'];
	$tel = $_POST['tel'];
	$datedebut=$_POST['datedebut'];
	$dd=strtotime($_POST['datedebut']);

	$codeerreur = 0;

	/* Connexion à la base de données */
	$con = pg_connect("host=$host dbname=$db user=$user password=$pass") or die('<div class="alert alert-danger" role="alert"><p>La connexion à la base données a échoué ! Vous pouvez revenir au formulaire en cliquant sur le bouton modifier.</p></div><a href="annulation.php?id='.$id.'&nom='.$nom.'&prenom='.$prenom.'&email='.$email.'&tel='.$tel.'&datedebut='.$datedebut.'"><button type="button" class="btn btn-info">Modifier</button></a><br/></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');
	/* correspond au fail de la connexion à la base */

	/* La requête permetant de selectionner la reservation à annuler */
	$query = 'SELECT * FROM reservation WHERE idreservation='.$id.' AND datedebut='.$dd.' AND (lower(nompers)=lower(\''.$nom.'\')) AND (lower(prenompers)=lower(\''.$prenom.'\')) AND (lower(adrmail)=lower(\''.$email.'\')) AND numtel=\''.$tel.'\';'; 

	/* Execution de la requête */
	$rs = pg_query($con, $query) or die('<div class="alert alert-danger" role="alert"><p>La demande de d\'annulation à échoué, veuillez verifier vos champs en appuyant sur modifier.</p></div><a href="annulation.php?id='.$id.'&nom='.$nom.'&prenom='.$prenom.'&email='.$email.'&tel='.$tel.'&datedebut='.$datedebut.'"><button type="button" class="btn btn-info">Modifier</button></a><br /></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');
	/* correspond au fail de la première requete */

	/* Fetch de la première ligne */
	$test = pg_fetch_assoc($rs)['idreservation'];

	/* Test de la première ligne vide ou pas */
	if (!empty($test)){
		/* La requête permetant de selectionner la reservation à annuler */
		$query = 'DELETE FROM reservation WHERE idreservation='.$id.' AND datedebut='.$dd.' AND (lower(nompers)=lower(\''.$nom.'\')) AND (lower(prenompers)=lower(\''.$prenom.'\')) AND (lower(adrmail)=lower(\''.$email.'\')) AND numtel=\''.$tel.'\';'; 

		/* Execution de la requête */
		$rs = pg_query($con, $query) or die('<div class="alert alert-danger" role="alert"><p>La demande de d\'annulation à échoué, veuillez verifier vos champs en appuyant sur modifier.</p></div><a href="annulation.php?id='.$id.'&nom='.$nom.'&prenom='.$prenom.'&email='.$email.'&tel='.$tel.'&datedebut='.$datedebut.'"><button type="button" class="btn btn-info">Modifier</button></a><br /></div></div></div><footer><div class="container"><div class="row"><div class="col-lg-12 text-center"><p>Copyright &copy; Vasseur Alexandre - PolyOsu Tools inc</p></div></div></div></footer>');
		/* correspond au fail de la première requete */
		$codeerreur = 1; /* Correspond à la reussite de l'annulation de la reservation */	
	}
	else
	{
		$codeerreur = 2; /* Correspond à une reservation innexistante donc soit il a mal rempli les champs soit il n'y avait tout simplement pas de reservation, dans le doute on redemande */
	}
	/* Fermeture de la connexion à la base de données */
	pg_close($con);
?>