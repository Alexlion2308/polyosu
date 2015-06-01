<!DOCTYPE html>
<html lang="fr">
<?php include("head-pages.php");?>
<body>
<?php include('header-pages.html'); ?>

<?php
$token=$_POST['token'];
$id = $_GET['id'];
$nom=$_GET['nom'];
$prenom = $_GET['prenom'];
$email = $_GET['email'];
$tel = $_GET['tel'];
$datedebut=$_GET['datedebut'];
?>

<div class="container">    
	<div class="row">
		<div class="box">
			<?php if ($token == 1)
				{
					include('../php/postAnnulation.php');
					if ($codeerreur == 1)
					{
						echo '<div class="alert alert-success" role="alert"><p>Votre réservation a bien été annulée !</p></div>';
						$token=2;
					}
					else if ($codeerreur == 2)
					{
						echo '<div class="alert alert-warning" role="alert"><p>Votre annulation a peut-être déja été effectuée ou alors veuillez verifier vos champs</p></div>';
					}
					
				}
				else
				{
					$token=1;
				}
			?>
			<h1 class="annulation">Formulaire d'annulation</h1>
			<?php echo '<form action="annulation.php" method="post">'; ?>
				<div class="input-group">
					<span class="input-group-addon" id="basic-addon1"><span class="glyphicon glyphicon-tag" aria-hidden="true"></span></span>
					<?php echo '<input type="text" class="form-control" placeholder="Numéro du produit" aria-describedby="basic-addon1" name="id" required="required" value="'.$id.'">'; ?> 
				</div>
				<div class="input-group">
					<span class="input-group-addon" id="basic-addon1"><span class="glyphicon glyphicon-user" aria-hidden="true"></span></span>
					<?php echo '<input type="text" class="form-control" placeholder="Nom" aria-describedby="basic-addon1" name="nom" required="required" value="'.$nom.'">'; ?> 
				</div>	
				<div class="input-group">
					<span class="input-group-addon" id="basic-addon1"><span class="glyphicon glyphicon-user" aria-hidden="true"></span></span>
					<?php echo '<input type="text" class="form-control" placeholder="Prénom" aria-describedby="basic-addon1" name="prenom" required="required" value="'.$prenom.'">'; ?> 
				</div>	
				<div class="input-group">
					<span class="input-group-addon" id="basic-addon1"><span class="glyphicon glyphicon-envelope" aria-hidden="true"></span></span>
					<?php echo '<input type="email" class="form-control" placeholder="jean.dupont@example.com" aria-describedby="basic-addon1" name="email" required="required" value="'.$email.'">'; ?>
				</div>
				<div class="input-group">
					<span class="input-group-addon" id="basic-addon1"><span class="glyphicon glyphicon-earphone" aria-hidden="true"></span></span>
					<?php echo '<input type="tel" class="form-control" placeholder="Numéro de téléphone" aria-describedby="basic-addon1" name="tel" required="required" value="'.$tel.'">'; ?>
				</div>
				<div class="input-group">
					<span class="input-group-addon" id="basic-addon1"><span value="Date de debut" aria-hidden="true"></span>Date de début</span>
				</div>	
				<div class="input-group">
					<span class="input-group-addon" id="basic-addon1"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
					<?php echo '<input type="date" class="form-control" placeholder="Date de début (Format : jj/mm/aaaa)" aria-describedby="basic-addon1" name="datedebut" required="required" value="'.$datedebut.'">'; ?>
				</div>
				<?php 
					echo '<input type="hidden" value="'.$token.'" name="token">';
					if ($token != 2)
					{
						echo '<a class="annulation"><button type="submit" value="Poster" class="btn btn-danger">Annuler</button></a><br/>';
					}
					else
					{
						echo '<a class="annulation" href="../index.php"><button type="button" class="btn btn-info">Retour</button></a><br/>';
						
					}
				?>
			</form>
		</div>
	</div>
</div>
<?php include('footer-pages.html') ; ?>
<?php include('scripts-pages.php'); ?>
</body>
</html>