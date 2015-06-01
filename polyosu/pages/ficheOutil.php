<!DOCTYPE html>
<html lang="fr">
<?php include("head-pages.php");?>
<body>
<?php include('header-pages.html'); ?>

<?php
$token=$_POST['token'];
$pdt = $_GET['pdt'];
$nom=$_GET['nom'];
$prenom = $_GET['prenom'];
$email = $_GET['email'];
$tel = $_GET['tel'];
$datedebut=$_GET['datedebut'];
$datefin=$_GET['datefin'];
?>

<div class="container">    
    <div class="row">
        <div class="box">
            <div class="col-lg-12">
				<h1 class="ficheOutil">Fiche de l'outil</h1>
				<?php include('../php/getFicheOutil.php'); ?>
            </div>
		</div>
	</div>
	<div class="row">
		<div class="box">
			<?php if ($token == 1)
				{
					include('../php/postReservation.php');
					if ($codeerreur == 1)
					{
						$unixday=86400;
						$montant = strtotime($datefin);
						$montant = $montant-strtotime($datedebut);
						$montant = $montant+$unixday;
						$montant = $montant/$unixday;
						$montant = $montant*$row['tarif']; 
						echo '<div class="alert alert-success" role="alert"><p>Votre réservation a bien été enregistée, veuillez noter votre numéro de produit : n°'.$idresa.' et votre date de début de réservation !</p><br/><p>Le montant à payer sera de : '.$montant.' € TTC</p></div>';
						$token=2;
					}
					else if ($codeerreur == 2)
					{
						echo '<div class="alert alert-warning" role="alert"><p>Nous sommes désolé mais nous n\'avons pas de disponibiltés pour ce produit à ces dates, vous pouvez essayer d\'autres dates</p></div>';
					}
					
				}
				else
				{
					$token=1;
				}
			?>
			<h1 class="ficheOutil">Formulaire de réservation</h1>
			<?php echo '<form action="ficheOutil.php?pdt='.$pdt.'" method="post">'; ?>
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
					<span class="input-group-addon" id="basic-addon1"><span value="Date de fin" aria-hidden="true"></span>Date de fin</span>
				</div>	
				<div class="input-group">
					<span class="input-group-addon" id="basic-addon1"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></span>
					<?php echo '<input type="date" class="form-control" placeholder="Date de début (Format : jj/mm/aaaa)" aria-describedby="basic-addon1" name="datedebut" required="required" value="'.$datedebut.'">'; ?>
					<span class="input-group-addon" id="basic-addon1"><span class="glyphicon glyphicon-arrow-right" aria-hidden="true"></span></span>
					<?php echo '<input type="date" class="form-control" placeholder="Date de fin (Format : jj/mm/aaaa)" aria-describedby="basic-addon1" name="datefin" required="required" value="'.$datefin.'">'; ?>
				</div>
				<?php 
					echo '<input type="hidden" value="'.$token.'" name="token">';
					if ($token != 2)
					{
						echo '<a class="ficheOutil2"><button type="submit" value="Poster" class="btn btn-success ficheOutil">Réserver</button></a><br/>';
					}
					else
					{
						echo '<a class="ficheOutil2" href="categorieSpe.php?id='.$row['categorie'].'"><button type="button" class="btn btn-info">Retour</button></a><br/>';
						
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